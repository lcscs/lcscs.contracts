## How to build the lcscs.contracts

### Preconditions
Ensure an appropriate version of `lcscs.cdt` is installed. Installing `lcscs.cdt` from binaries is sufficient, follow the [`lcscs.cdt` installation instructions steps](https://github.com/lcscs/lcscs.cdt/tree/master/#binary-releases) to install it. To verify if you have `lcscs.cdt` installed and its version run the following command 

```sh
lcscs-cpp -v
```

#### Build contracts using the build script

##### To build contracts alone
Run the `build.sh` script in the top directory to build all the contracts.

##### To build the contracts and unit tests
1. Ensure an appropriate version of `lcscs` has been built from source and installed. Installing `lcscs` from binaries `is not` sufficient. You can find instructions on how to do it [here](https://github.com/lcscs/scs/blob/master/README.md) in section `Building from Sources`.
2. Run the `build.sh` script in the top directory with the `-t` flag to build all the contracts and the unit tests for these contracts.

#### Build contracts manually

To build the `lcscs.contracts` execute the following commands.

On all platforms except macOS:
```sh
cd you_local_path_to/lcscs.contracts/
rm -fr build
mkdir build
cd build
cmake ..
make -j$( nproc )
cd ..
```

For macOS:
```sh
cd you_local_path_to/lcscs.contracts/
rm -fr build
mkdir build
cd build
cmake ..
make -j$(sysctl -n hw.ncpu)
cd ..
```

#### After build:
* If the build was configured to also build unit tests, the unit tests executable is placed in the _build/tests_ folder and is named __unit_test__.
* The contracts (both `.wasm` and `.abi` files) are built into their corresponding _build/contracts/\<contract name\>_ folder.
* Finally, simply use __clscs__ to _set contract_ by pointing to the previously mentioned directory for the specific contract.

## How to deploy the lcscs.contracts

### To deploy lcscs.bios contract execute the following command:
Let's assume your account name to which you want to deploy the contract is `testerbios`
```
clscs set contract testerbios you_local_path_to/lcscs.contracts/build/contracts/lcscs.bios/ -p testerbios
```

### To deploy lcscs.msig contract execute the following command:
Let's assume your account name to which you want to deploy the contract is `testermsig`
```
clscs set contract testermsig you_local_path_to/lcscs.contracts/build/contracts/lcscs.msig/ -p testermsig
```

### To deploy lcscs.system contract execute the following command:
Let's assume your account name to which you want to deploy the contract is `testersystem`
```
clscs set contract testersystem you_local_path_to/lcscs.contracts/build/contracts/lcscs.system/ -p testersystem
```

### To deploy lcscs.token contract execute the following command:
Let's assume your account name to which you want to deploy the contract is `testertoken`
```
clscs set contract testertoken you_local_path_to/lcscs.contracts/build/contracts/lcscs.token/ -p testertoken
```

### To deploy lcscs.wrap contract execute the following command:
Let's assume your account name to which you want to deploy the contract is `testerwrap`
```
clscs set contract testerwrap you_local_path_to/lcscs.contracts/build/contracts/lcscs.wrap/ -p testerwrap
```