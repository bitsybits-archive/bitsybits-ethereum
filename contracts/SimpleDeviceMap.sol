pragma solidity ^0.4.18;

contract SimpleDeviceMap {
    mapping(bytes8 => string) private commands;
    mapping(bytes8 => address) private owners;
    
    modifier onlyDeviceOwnerOrNew (bytes8 _device) {
        require(canUseDevice(_device));
        _;
    }

    function setCommand (bytes8 _device, string _command) public 
    onlyDeviceOwnerOrNew(_device)
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
        return owners[_device] == msg.sender || owners[_device] == 0x0;
    }
}