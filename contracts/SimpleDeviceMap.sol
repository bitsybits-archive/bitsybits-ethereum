pragma solidity ^0.4.18;

import './Ownable.sol';
import './Strings.sol';

contract SimpleDeviceMap is Ownable {
    using Strings for *;
    
    bytes8 public demoDevice;

    mapping(bytes8 => string) private commands;
    mapping(bytes16 => string) private libraries;
    mapping(bytes8 => bytes16[]) private librariesUsedInCommand;

    mapping(bytes8 => address) private deviceOwners;
    mapping(bytes16 => address) private libraryOwners;
    
    function SimpleDeviceMap() public {
        setDemoDevice("TEST");
    }
    
    modifier onlyUsableDevices (bytes8 _device) {
        require(canUseDevice(_device));
        _;
    }

    modifier onlyLibraryOwner (bytes16 _libname) {
        require(canModifyLibrary(_libname));
        _;
    }
    
    function setDemoDevice (bytes8 _device) public
    onlyOwner
    {
        demoDevice = _device;
    }

    function setCommand (bytes8 _device, string _command, bytes16[] _libnames) public 
    onlyUsableDevices(_device)
    {
        commands[_device] = _command;
        deviceOwners[_device] = msg.sender;
        librariesUsedInCommand[_device] = _libnames;
    }
    
    function getCommand (bytes8 _device) constant public
    returns (string)
    {
        string memory builtCommand = "";
        bytes16[] memory libnames = librariesUsedInCommand[_device];
        for (var i = 0; i < libnames.length; ++i) {
            builtCommand = builtCommand.toSlice().concat(libraries[libnames[i]].toSlice());
        }

        return builtCommand.toSlice().concat(commands[_device].toSlice());
    }

    function setLibrary (bytes16 _libname, string _command) public 
    onlyLibraryOwner(_libname)
    {
        libraries[_libname] = _command;
        libraryOwners[_libname] = msg.sender;
    }

    function getLibrary (bytes16 _libname) constant public 
    returns (string)
    {
        return libraries[_libname];
    }
    
    function canUseDevice (bytes8 _device) constant public
    returns (bool)
    {
        return demoDevice == _device
        || deviceOwners[_device] == msg.sender
        || deviceOwners[_device] == 0x0;
    }

    function canModifyLibrary (bytes16 _libname) constant public
    returns (bool)
    {
        return libraryOwners[_libname] == 0x0; // || libraryOwners[_libname] == msg.sender;
    }
}