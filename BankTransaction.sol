// SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.0; 

import "@openzeppelin/contracts/utils/Strings.sol";


contract Bank{

    uint pay_id = 1;
   
    //specifies bank transaction information. 
    struct BankTransaction
    {
            

        string payment_id;   
        address client_id; 
        address receiver; 
        uint amount;
        uint256 timestamp; 
        string note; //note to payment
        bytes20 tx_hash;
    }

   
     
        mapping(string => BankTransaction) public bank_tx;
        mapping(address => string[]) public tx_list;

  
        function AddNewPayment(address payable _receiver, uint _amount, string memory _note)public payable
        
        {
            //create a new payment
            string memory _payment_id = string(abi.encodePacked("payment_id " , " + ", Strings.toString(pay_id))); // String concantenation
            uint256 _timestamp = block.timestamp; // time of payment
            bytes20 _tx_hash = ripemd160(abi.encodePacked(_payment_id, msg.sender, _receiver, _amount, _timestamp)); //transaction hash.

            //Create Transaction
             BankTransaction memory transaction = BankTransaction
             (_payment_id, msg.sender, _receiver, _amount, _timestamp, _note, _tx_hash); 

            //Map transaction
            bank_tx[_payment_id] = transaction;
            

            // Add transaction to map array
            tx_list[msg.sender].push(_payment_id); //msg.sender calls the client id
            
            // Increment payment id number
                pay_id += 1;
        }
     

        function PaymentInfo(string memory _payment_id) public view returns
            (string memory, address, address, uint, uint256, string memory, bytes20)

        {
            /* get the payment by its identifier */
            return (
             bank_tx[_payment_id].payment_id,
             bank_tx[_payment_id].client_id,
             bank_tx[_payment_id].receiver,
             bank_tx[_payment_id].amount,
             bank_tx[_payment_id].timestamp,
             bank_tx[_payment_id].note,
             bank_tx[_payment_id].tx_hash
         );
           
        }
            
            
        function getAllPayments(address payable _client) public view returns (string [] memory)
            {
                /* get client transactions to a particular customer */ 
                   return tx_list[_client];
        }
    
        
}
