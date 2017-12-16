pragma solidity ^0.4.18;

import './Ownable.sol';

contract SimpleDeviceMap is Ownable {
    mapping(bytes8 => string) private commands;
    mapping(bytes8 => address) private owners;
    bytes8 public demoDevice;
    
    function SimpleDeviceMap() public {
        setDemoDevice("TEST");
    }
    
    modifier onlyUsableDevices (bytes8 _device) {
        require(canUseDevice(_device));
        _;
    }
    
    function setDemoDevice (bytes8 _device) public
    onlyOwner
    {
        demoDevice = _device;
    }

    function setCommand (bytes8 _device, string _command) public 
    onlyUsableDevices(_device)
    {
        commands[_device] = _command;
        owners[_device] = msg.sender;
    }
    
    function getCommand (bytes8 _device) constant public
    returns (string)
    {
        return commands[_device];
    }
    
    function canUseDevice (bytes8 _device) constant public
    returns (bool)
    {
        return demoDevice == _device
        || owners[_device] == msg.sender
        || owners[_device] == 0x0;
    }
}