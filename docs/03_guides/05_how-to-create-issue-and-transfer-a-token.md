## How to create, issue and transfer a token

## Step 1: Obtain Contract Source

Navigate to your contracts directory.

```text
cd CONTRACTS_DIR
```

Pull the source
```text
git clone https://github.com/lcscs/lcscs.contracts --branch master --single-branch
```

```text
cd lcscs.contracts/contracts/lcscs.token
```

## Step 2: Create Account for Contract
[[info]]
| You may have to unlock your wallet first!

```shell
clscs create account lcscs lcscs.token scs6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
```

## Step 3: Compile the Contract

```shell
lcscs-cpp -I include -o lcscs.token.wasm src/lcscs.token.cpp --abigen
```

## Step 4: Deploy the Token Contract

```shell
clscs set contract lcscs.token CONTRACTS_DIR/lcscs.contracts/contracts/lcscs.token --abi lcscs.token.abi -p lcscs.token@active
```

Result should look similar to the one below:
```shell
Reading WASM from ...
Publishing contract...
executed transaction: 69c68b1bd5d61a0cc146b11e89e11f02527f24e4b240731c4003ad1dc0c87c2c  9696 bytes  6290 us
#         lcscs <= lcscs::setcode               {"account":"lcscs.token","vmtype":0,"vmversion":0,"code":"0061736d0100000001aa011c60037f7e7f0060047f...
#         lcscs <= lcscs::setabi                {"account":"lcscs.token","abi":"0e656f73696f3a3a6162692f312e30000605636c6f73650002056f776e6572046e61...
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```

## Step 5: Create the Token

```shell
clscs push action lcscs.token create '[ "lcscs", "1000000000.0000 SYS"]' -p lcscs.token@active
```

Result should look similar to the one below:
```shell
executed transaction: 0e49a421f6e75f4c5e09dd738a02d3f51bd18a0cf31894f68d335cd70d9c0e12  120 bytes  1000 cycles
#   lcscs.token <= lcscs.token::create          {"issuer":"lcscs","maximum_supply":"1000000000.0000 SYS"}
```

An alternate approach uses named arguments:

```shell
clscs push action lcscs.token create '{"issuer":"lcscs", "maximum_supply":"1000000000.0000 SYS"}' -p lcscs.token@active
```

Result should look similar to the one below:
```shell
executed transaction: 0e49a421f6e75f4c5e09dd738a02d3f51bd18a0cf31894f68d335cd70d9c0e12  120 bytes  1000 cycles
#   lcscs.token <= lcscs.token::create          {"issuer":"lcscs","maximum_supply":"1000000000.0000 SYS"}
```
This command created a new token `SYS` with a precision of 4 decimals and a maximum supply of 1000000000.0000 SYS.  To create this token requires the permission of the `lcscs.token` contract. For this reason, `-p lcscs.token@active` was passed to authorize the request.

## Step 6: Issue Tokens

The issuer can issue new tokens to the issuer account in our case `lcscs`. 

```text
clscs push action lcscs.token issue '[ "lcscs", "100.0000 SYS", "memo" ]' -p lcscs@active
```

Result should look similar to the one below:
```shell
executed transaction: a26b29d66044ad95edf0fc04bad3073e99718bc26d27f3c006589adedb717936  128 bytes  337 us
#   lcscs.token <= lcscs.token::issue           {"to":"lcscs","quantity":"100.0000 SYS","memo":"memo"}
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```

## Step 7: Transfer Tokens

Now that account `lcscs` has been issued tokens, transfer some of them to account `bob`.

```shell
clscs push action lcscs.token transfer '[ "lcscs", "bob", "25.0000 SYS", "m" ]' -p lcscs@active
```

Result should look similar to the one below:
```text
executed transaction: 60d334850151cb95c35fe31ce2e8b536b51441c5fd4c3f2fea98edcc6d69f39d  128 bytes  497 us
#   lcscs.token <= lcscs.token::transfer        {"from":"lcscs","to":"bob","quantity":"25.0000 SYS","memo":"m"}
#         lcscs <= lcscs.token::transfer        {"from":"lcscs","to":"bob","quantity":"25.0000 SYS","memo":"m"}
#           bob <= lcscs.token::transfer        {"from":"lcscs","to":"bob","quantity":"25.0000 SYS","memo":"m"}
warning: transaction executed locally, but may not be confirmed by the network yet         ]
```
Now check if "bob" got the tokens using [clscs get currency balance](https://developers.scs.io/lcscs-clscs/reference#currency-balance)

```shell
clscs get currency balance lcscs.token bob SYS
```

Result:
```text
25.00 SYS
```

Check "lcscs's" balance, notice that tokens were deducted from the account 

```shell
clscs get currency balance lcscs.token lcscs SYS
```

Result:
```text
75.00 SYS
```
