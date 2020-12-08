#pragma once

#include <lcscs/lcscs.hpp>
#include <lcscs/ignore.hpp>
#include <lcscs/transaction.hpp>

namespace lcscs {
   /**
    * @defgroup lcscswrap lcscs.wrap
    * @ingroup lcscscontracts
    * lcscs.wrap contract simplifies Block Producer superuser actions by making them more readable and easier to audit.

    * It does not grant block producers any additional powers that do not already exist within the
    * system. Currently, 15/21 block producers can already change an account's keys or modify an
    * account's contract at the request of ECAF or an account's owner. However, the current method
    * is opaque and leaves undesirable side effects on specific system accounts.
    * lcscs.wrap allows for a cleaner method of implementing these important governance actions.
    * @{
    */
   class [[lcscs::contract("lcscs.wrap")]] wrap : public contract {
      public:
         using contract::contract;

         /**
          * Execute action.
          *
          * Execute a transaction while bypassing regular authorization checks.
          *
          * @param executer - account executing the transaction,
          * @param trx - the transaction to be executed.
          *
          * @pre Requires authorization of lcscs.wrap which needs to be a privileged account.
          *
          * @post Deferred transaction RAM usage is billed to 'executer'
          */
         [[lcscs::action]]
         void exec( ignore<name> executer, ignore<transaction> trx );

         using exec_action = lcscs::action_wrapper<"exec"_n, &wrap::exec>;
   };
   /** @}*/ // end of @defgroup lcscswrap lcscs.wrap
} /// namespace lcscs
