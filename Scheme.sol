//Remix Compiler 0.4.24+conmmit.e67f0147

pragma solidity >=0.4.22 <0.7.0;

contract Scheme {

/************************DEFINE************************/

    uint256 Value_Amount;//The amount of the transaction
    uint256 Value_Deposit;//The deposi of the transaction
    uint256 Time_First;//Record the time Bob finished the first step(Bob pays)
    uint256 Time_Second;//Record the time Alice finished the second step(Alice sends encrypted key)
    uint256 Time_Third;//Record the time Bob finished the third step(Bob reports)
    uint256 Time_Rep = 300 seconds;//The time Bob can send report after transaction is finished 
    uint256 Time_Trans = 300 seconds;//The time limit of each step
    string PubKey_Buyer;//Bob's public key
    string EncryptedKey_Seller;//Alice's key encrypted(EK) by Bob's PK
    string EvidenceKey;//Bob sends the key he recieved as evidence to the smart contract
    string ReasonType;//Bob chooses the reason for reporting Alice
    string Hash_Data;//Alice's selling data(verify by web)
    string Hash_Key;//Alice's key's hash value(verify by web)
	
    address public AddressPay;//Alice can recieve the money by the address
    address public AddressBuyer;//The address of Bob
    address public AddressVerify;//The address of the person who helps veriifying
    string public DataAddress = "www.cugdatatrade.com";//The adress of the big data
    string public CalHash = "https://emn178.github.io/online-tools/sha256_checksum.html";//The web for calculating sha256
	
    bool Goal_Amount = false;//Judge if Alice sets the amount
    bool Goal_HashData = false;//Judge if Alice uploads Hash value of the data
    bool Goal_HashKey = false;//Judge if Alice uploads Hash value of the key
    bool Goal_Deposit = false;//Judge if Alice sends the deposit
    bool Goal_Money = false;//Judge if Bob sends the money 
    bool Goal_PubKeyB = false;//Judge if Bob sends his public key 
    bool Goal_EnK = false;//Judge if Alice sends the encrypted key
    bool Goal_GotRep = false;//Jugde if Bob sends the report
    bool Goal_Verify = false;//Judge if the report sent by Bob is true
    bool Goal_Success = false;//Judge if the transaction is successful
    bool Goal_First = false;//Judge if the time of first step is run out
    bool Goal_Second = false;//Judge if the time of second step is run out
    bool Goal_Third = false;//Judge if the time of third step is run out

    event SetAmountAndDeposit(uint);
    event UploadHashData(string);
    event UploadHashKey(string);
    event GotMoney(uint,address);
    event GotDeposit(uint,address);
    event UploadPubKeyB(string);
    event UploadEncrypedKey(string);
    event GotReport(string,string);
    event VerifyResult(bool);
    event TransResult(bool);
    
/************************INIT************************/

	//The constructor of the smart contract
	constructor () public payable {
        AddressPay = msg.sender;
    }
    
    //Show the time now
    function CurrTimeInSeconds() public view returns (uint256) {
        return now;
    }

/************************VIEW************************/

	//View the amount of the transaction
	function get_amount () public view returns (uint256) {
		return Value_Amount;
	}
	
	//View the deposit of the transaction
	function get_deposit () public view returns (uint256) {
		return Value_Deposit;
	}
    
    //View the Bob's public key of the transaction
	function get_pubkeyB() view public returns(string) {
        return PubKey_Buyer;
    }
    
    //View the encrypted key of Alice
	function get_enkey () view public returns(string) {
        return EncryptedKey_Seller;
    }
    
    //View the hash value of the key of Alice
    function get_hash_key () view public returns(string) {
        return Hash_Key;
    }
    
    //View the hash value of the encrypted data
    function get_hash_data () view public returns(string) {
        return Hash_Data;
    }
    
    /*
    //View the status of goal of amount
    function goal_amount () view public returns(bool) {
        return Goal_Amount;
    }
    
     //View the status of goal of deposit
    function goal_deposit () view public returns(bool) {
        return Goal_Deposit;
    }
    
    //View the status of goal of hash
    function goal_hash () view public returns(bool) {
        return Goal_Hash;
    }
    
    //View the status of goal of money
    function goal_money () view public returns(bool) {
        return Goal_Money;
    }
    
    //View the status of goal of public key of Bob
    function goal_pubkeyB () view public returns(bool) {
        return Goal_PubKeyB;
    }
    
    //View the status of goal of encrypted key
    function goal_enkey () view public returns(bool) {
        return Goal_EnK;
    }
    
    //View the status of goal of transaction
    function goal_success () view public returns(bool) {
        return Goal_Success;
    }
    
    //View the status of goal of verfication
    function goal_verify () view public returns(bool) {
        return Goal_Verify;
    }
    
    //View the status of first step
    function goal_first () view public returns(bool) {
        return Goal_First;
    }
    
    //View the status of second step
    function goal_second () view public returns(bool) {
        return Goal_Second;
    }
    
    //View the status of third step
    function goal_third () view public returns(bool) {
        return Goal_Third;
    }
    */
    
    //View the time Bob finished the first step
    function view_first () public view returns (uint256){
        return Time_First;
    }
    
    //View the time Alice finished the second step
    function view_second () public view returns (uint256){
        return Time_Second;
    }
    
    //View the time Alice finished the third step
    function view_third () public view returns (uint256){
        return Time_Third;
    }
    
    //View the evidence and reason
    function show_evidence_reason () view public returns(string, string) {
        return (EvidenceKey, ReasonType);
    }
    
    //Show the type of the reason
    function show_reason () pure public returns(string) {
        return "Type-1: Wrong key || Type-2: Messy watermark || Type-3: Two or more watermarks";
    }
    
    //Inquire the amount of a specific account
	function get_balance (address AccountOrContract) constant public returns(uint) {
        return AccountOrContract.balance;
    }

/************************PROCESS************************/

    //Alice sets the amount and deposit of the trasnsaction
	function set_amount (uint256 Amount) public {
		if (msg.sender == AddressPay) {
		    Value_Amount = Amount;
	    	Value_Deposit = 2 * Value_Amount;
		    Goal_Amount = true;
		    emit SetAmountAndDeposit(Value_Amount);
		}
		else {
		    Goal_Amount = false;
	        revert("Wrong input.");
		}
	}
	
	//Alice uploads the hash value of the data
    function upload_hash_data (string HashData) public {
        if (Goal_Amount == true) {
            if (msg.sender == AddressPay) {
                Hash_Data = HashData;
                Goal_HashData = true;
                emit UploadHashData(Hash_Data);
            }
            else {
                Goal_HashData = false;
                revert("Only the seller can upload hash value of the data.");
            }
        }
        else {
            Goal_HashData = false;
            revert("Please set the amount first.");
        }
    }
    
    //Alice uploads the hash value of the key 
    function upload_hash_key (string HashKey) public {
        if (Goal_HashData == true) {
            if (msg.sender == AddressPay) {
                Hash_Key = HashKey;
                Goal_HashKey = true;
                emit UploadHashKey(Hash_Key);
            }
            else {
                Goal_HashKey = false;
                revert("Only the seller can upload hash value of the key.");
            }
        }
        else {
            Goal_HashKey = false;
            revert("Please upload hash value of the data first.");
        }
    }
    
    //Alice sends the deposit to the smart contract
    function send_deposit () public payable returns(bool) {
        if (Goal_HashKey == true) {
            if (msg.sender == AddressPay) {
                if (msg.value == Value_Deposit) {
                    Goal_Deposit = true;
                    Time_First = now;
                    emit GotDeposit(Value_Deposit, this);
                    return address(this).send(msg.value);
                }
                else {
                    Goal_Deposit = false;
                    revert("The value of the desposit is wrong.");
                }
            }
            else {
                Goal_Deposit = false;
                revert("Only the seller can send the desposit.");
            }
        }
        else {
            Goal_Deposit = false;
            revert("Please upload the hash value of the key first.");
        }
    }    
    
    //Bob sends the money to the smart contract
    function send_money () public payable returns(bool) {
        AddressBuyer = msg.sender;
        if (Goal_Deposit == true) {
            if (AddressBuyer != AddressPay) {
                if (now <= Time_First + Time_Trans) {
                    Goal_Money = true;
                    Goal_First = true;
                    emit GotMoney(Value_Amount, this);
                    return address(this).send(msg.value);
                }
                else {
                    Goal_First = false;
                    revert("Time is run out (first step).");
                }
            }
            else {
                Goal_Money = false;
                revert("Seller can not send the money.");
            }
        }
        else {
            Goal_Money = false;
            revert("Seller should send deposit first.");
        }
    }
    //Bob Uploads the public key
	function upload_pubkey_buyer (string PubKey) public {
        if (Goal_Money == true) {
        	if (AddressBuyer != AddressPay) {	
            	PubKey_Buyer = PubKey;
            	Goal_PubKeyB = true;
            	Time_Second = now;
            	emit UploadPubKeyB(PubKey_Buyer);
        	}
        	else {
            	Goal_PubKeyB = false;
            	revert("Seller can not send the money.");
        	}
        }
        else {
            Goal_PubKeyB = false;
            revert("Buyer should send money first.");
        }
    }
    
    //Alice uploads the encrypted key
    function upload_encryptedkey (string EnKey) public {
        if (Goal_Money == true) {
            if (Goal_PubKeyB == true) {
        	    if (msg.sender == AddressPay) {
        		    if (now <= Time_Second + Time_Trans) {		
            		    EncryptedKey_Seller = EnKey;
            		    Goal_EnK = true;
            		    Goal_Second = true;
            		    Time_Third = now;
            		    emit UploadEncrypedKey(EncryptedKey_Seller); 
        		    }
        		    else {
            		    Goal_Second = false;
            		    revert("Time is run out (second step).");   
        		    }
        	    }
		 	    else {
            	    Goal_EnK = false;
            	    revert("Only seller can send encrypted key.");   
        	    }
            }
            else {
                Goal_EnK = false;
                revert("Please ask buyer to send public key first.");   
            }
        }
        else {
            Goal_EnK = false;
            revert("Please ask buyer to send money first.");
        }
    }
    
    //Bob sends the report to the smart contract and the key is evidence
    function report_send (string Evidence, string Reason) public {
        if (Goal_EnK == true) {
            if (msg.sender == AddressBuyer) {
                if (now <= Time_Third + Time_Rep) {
                    EvidenceKey = Evidence;
                    ReasonType = Reason;
                    Goal_GotRep = true;
                    Goal_Third = true;
                    emit GotReport(EvidenceKey, ReasonType);
                }
                else {
                    Goal_Third = false;
                    revert("Time is run out (third step).");
                }
            }
            else {
                Goal_GotRep = false;
                revert("Only the buyer can send the report.");
            }
        }
        else {
            Goal_GotRep = false;
            revert("Plaese ask seller to send encrypted key first.");
        }
    }
    
    //Others vertify the report sent by Bob
    function report_verify (bool Verify) public {
        if (Goal_GotRep == true) {
        	if (msg.sender != AddressPay && msg.sender != AddressBuyer) {
            	AddressVerify = msg.sender;
            	Goal_Verify = Verify;
            	emit VerifyResult(Goal_Verify);
        	}
        	else {
            	Goal_Verify = false;
            	revert("Only the third part can vertify the report.");
        	}
 		}
        else {
            Goal_Verify = false;
            revert("Smart contract did not get the report.");
        }
    }
    
/************************RESULT************************/
    
    //Different results of the transaction
    function end_transaction () public {
        //The transaction is successful
        if (msg.sender == AddressBuyer && 
            Goal_Amount == true &&
            Goal_HashData == true &&
            Goal_HashKey == true &&
            Goal_Money == true &&
            Goal_PubKeyB == true &&
            Goal_EnK == true &&
            Goal_Verify == false) {
            Goal_Success = true;
            emit TransResult(Goal_Success);
            AddressPay.transfer(Value_Amount);
            AddressPay.transfer(Value_Deposit);
        }
        //Only the seller pays but the time is run out
        else if (msg.sender == AddressPay &&
                 Goal_Deposit == true &&
                 Goal_First == false) {
            Goal_Success = false;
            emit TransResult(Goal_Success);
            AddressPay.transfer(Value_Deposit);
        }
        //Both pay but time is run out
        else if (Goal_Money = true &&
                 Goal_Second == false) {
            Goal_Success = false;
            emit TransResult(Goal_Success);
            AddressPay.transfer(Value_Deposit);
            AddressBuyer.transfer(Value_Amount);
        }
        //If Bob does not send report and report time is run out Alice can end 
        else if (Goal_EnK == true &&
                 Goal_GotRep == false &&
                 (now > Time_Third + Time_Rep)) {
            Goal_Success = true;
            emit TransResult(Goal_Success);
            AddressPay.transfer(Value_Amount);
            AddressPay.transfer(Value_Deposit);
        }
        //Bob's report is right
        else if (msg.sender == AddressVerify &&
                 Goal_GotRep == true &&
                 Goal_Verify == true) {
            Goal_Success = false;
            emit TransResult(Goal_Success);
            AddressBuyer.transfer(Value_Deposit);
            AddressBuyer.transfer(Value_Amount);
        }
        //Bob's report is wrong
        else if (msg.sender == AddressVerify &&
                 Goal_GotRep == true &&
                 Goal_Verify == false) {
            Goal_Success = false;
            emit TransResult(Goal_Success);
            AddressPay.transfer(Value_Deposit);
            AddressPay.transfer(Value_Amount);
        }
        else
            revert("Wait...");
    }
}
