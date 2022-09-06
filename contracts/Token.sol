// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TLP is Ownable{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 decimalfactor;
    uint256 public Max_Token;
    bool mintAllowed = true;
    uint256 taxPercent;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory SYMBOL,
        string memory NAME,
        uint8 DECIMALS
        // address developmentAndMarketing,
        // address founder,
        // address executiveTeam,
        // address adivisor,
        // address bountiesAndAirdrops,
        // address reserves,
        // address others
        ){
        symbol = SYMBOL;
        name = NAME;
        decimals = DECIMALS;
        decimalfactor = 10**uint256(decimals);
        Max_Token = 1_00_00_000 * decimalfactor;
        taxPercent = 10;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        uint256 actualAmount = _value;
        uint256 taxAmount = taxPercent * _value / 100;
        _value -= taxAmount;

        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(
            balanceOf[_from] >= actualAmount,
            "ERC20: 'from' address balance is low"
        );
        require(
            balanceOf[_to] + _value >= balanceOf[_to],
            "ERC20: Value is negative"
        );

        balanceOf[_from] -= actualAmount;
        balanceOf[_to] += _value;
        balanceOf[super.owner()] +=  taxAmount / 2;
        burn(taxAmount / 2);

        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value)
        public
        virtual
        returns (bool)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool success) {
        require(
            _value <= allowance[_from][msg.sender],
            "ERC20: Allowance error"
        );
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(
            balanceOf[msg.sender] >= _value,
            "ERC20: Transfer amount exceeds user balance"
        );

        balanceOf[msg.sender] -= _value;
        
        totalSupply -= _value;
        mintAllowed = true;
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    function mint(address to, uint256 value) public returns (bool success) {
        require(
            Max_Token >= (totalSupply + value),
            "ERC20: Max Token limit exceeds"
        );
        require(mintAllowed, "ERC20: Max supply reached");

        if (Max_Token == (totalSupply + value)) {
            mintAllowed = false;
        }

        require(msg.sender == super.owner(), "ERC20: Only Owner Can Mint");

        balanceOf[to] += value;
        totalSupply += value;

        require(
            balanceOf[to] >= value,
            "ERC20: Transfer amount cannot be negative"
        );

        emit Transfer(address(0), to, value);
        return true;
    }
}
