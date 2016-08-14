# The Solidity Programming Language

Solidity is a high-level language whose syntax is similar to that of JavaScript and it is designed to compile to code for the Elementrem Virtual Machine.

All computers on the network are performing the command which you have presented. As well as Due to the highly-developed protocol contracts, all the information is reliable even in a computer environment that can not be trusted. This technology can definitely extend your application.
Provides platform for automating, refining, managing complex processes. Simplification of complex financial derivatives, intelligent and autonomous machines collaboration IoT devices. And You can use the computing power beyond the supercomputer. 

If you specify the right conditions, your requirements will be handled automatically by a computer connected to the Elementrem BlockChain Node. This is the Highly developed contract code. Validation and calculation, as well as by defining the function was to enable the Turing Complete code development.

### [Install Solidity (To build from source is unnecessary)](https://github.com/elementrem/solidity/releases) 
### [To build from source](solidity_build.md)
***

### Deploying your simple contract – Step by Step

***Keep in mind that This contract will consume approximately 0.006 Element.***


You should make sure whether the solidity compiler is applied or not.
```
> ele.getCompilers()
["Solidity"]
```

If the solidity is not applied, You can apply it manually.
```
> admin.setSolc("/usr/bin/solc")
"solc, the solidity compiler commandline interface\nVersion: 0.3.6-0/None-Linux/g++\n\npath: /usr/bin/solc"
```

- Compiling from the console

The [***Gele console***](https://github.com/elementrem/go-elementrem/blob/master/gele_command_readme.md) actually implmements a JavaScript Runtime Environment. Let's set a variable containing our source code:
```
> var smcontractSource = 'contract SMcontract {   mapping (address => string) entryLog;    function setEntry(string smcontractEntry) {     entryLog[msg.sender] = smcontractEntry;   }    function getMyEntry() constant returns (string) {     return entryLog[msg.sender];   } }'
```

And now we can proceed to compile this source code.

```
> var smcontractCompiled = web3.ele.compile.solidity(smcontractSource);
```

The call to the solidity function returns us a JSON object which contains the EVM byte code   
(smcontractCompiled.SMcontract.code), as well as the ABI definition of the contract   
(smcontractCompiled.SMcontract.info.abiDefinition ).    

- Instantiating a contract    
The next step is to use the web3 elementrem helpers to instantiate a contract object:   
```
> var contract = web3.ele.contract(smcontractCompiled.SMcontract.info.abiDefinition);
```

This will give us an instantiated contract object containing the all important new function. new is what we'll use to actually deploy the contract to your Elementrem network. Since we're in Javascript land, new takes a call back as its final parameter to notify us of successful or failed deployment; lets set up this call back first:

```
> var callback = function(e, contract){
    if(!e) {
      if(!contract.address) {
        console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be confirmed……...");
      } else {
        console.log("Contract confirmed!!!");
        console.log(contract);
      }
    }
}
```

Next we'll need to define the contract initialization object which contains three key/value pairs:

`from` - the address that is posting the contract

`data` - the raw code from the contract

`gas` - the initial gas that we're posting for the contract

Let's construct the initalizer:
```
> var initializer =  {from:web3.ele.accounts[0], data: smcontractCompiled.SMcontract.code, gas: 300000}
```
ele.accounts[0] = First account. accounts[1] Secend account.

- Deploying the Contract
We are now ready to deploy! Remember that `new` method? We can finally use it:    
You will need to enter the password you entered when first importing the private key to unlock your account.

`> personal.unlockAccount(personal.listAccounts[0])`

```
> var smcontract = contract.new(initializer, callback);
Contract transaction send: TransactionHash: 0x111111111111111111111111111111111111111111 waiting to be confirmed……
        // Wait until the transaction is confirmed.
Contract confirmed!!!
[object Object]
```

- Writing to the contract
In order for us to write to the entryLog of the contract and have that update stored in the blockchain, we need to send a transaction to the contract address.

```
> smcontract.setEntry.sendTransaction("Hello Elementrem!", {from: ele.accounts[0]});
"0x111111111111111111111111111111111111111111111111111111111111111111"
```

Now if we read from the contract:

```
> smcontract.getMyEntry();
"Hello Elementrem!"
```

Congratulations! Your contract is alive and well on Elementrem blockchain.
