#pragma once

#include <lcscs/asset.hpp>
#include <lcscs/lcscs.hpp>

#include <string>

namespace lcscssystem {
   class system_contract;
}

namespace lcscs {

   using std::string;

   /**
    * lcscs.token contract defines the structures and actions that allow users to create, issue, and manage
    * tokens on lcscs based blockchains.
    */
   class [[lcscs::contract("lcscs.token")]] token : public contract {
      public:
         using contract::contract;

         /**
          * Allows `issuer` account to create a token in supply of `maximum_supply`. If validation is successful a new entry in statstable for token symbol scope gets created.
          *
          * @param issuer - the account that creates the token,
          * @param maximum_supply - the maximum supply set for the token created.
          *
          * @pre Token symbol has to be valid,
          * @pre Token symbol must not be already created,
          * @pre maximum_supply has to be smaller than the maximum supply allowed by the system: 1^62 - 1.
          * @pre Maximum supply must be positive;
          */
         [[lcscs::action]]
         void create( const name&   issuer,
                      const asset&  maximum_supply);
         /**
          *  This action issues to `to` account a `quantity` of tokens.
          *
          * @param to - the account to issue tokens to, it must be the same as the issuer,
          * @param quntity - the amount of tokens to be issued,
          * @memo - the memo string that accompanies the token issue transaction.
          */
         [[lcscs::action]]
         void issue( const name& to, const asset& quantity, const string& memo );

         /**
          * The opposite for create action, if all validations succeed,
          * it debits the statstable.supply amount.
          *
          * @param quantity - the quantity of tokens to retire,
          * @param memo - the memo string to accompany the transaction.
          */
         [[lcscs::action]]
         void retire( const asset& quantity, const string& memo );

         /**
          * Allows `from` account to transfer to `to` account the `quantity` tokens.
          * One account is debited and the other is credited with quantity tokens.
          *
          * @param from - the account to transfer from,
          * @param to - the account to be transferred to,
          * @param quantity - the quantity of tokens to be transferred,
          * @param memo - the memo string to accompany the transaction.
          */
         [[lcscs::action]]
         void transfer( const name&    from,
                        const name&    to,
                        const asset&   quantity,
                        const string&  memo );
         /**
          * Allows `ram_payer` to create an account `owner` with zero balance for
          * token `symbol` at the expense of `ram_payer`.
          *
          * @param owner - the account to be created,
          * @param symbol - the token to be payed with by `ram_payer`,
          * @param ram_payer - the account that supports the cost of this action.
          *
          * More information can be read [here](https://github.com/lcscs/lcscs.contracts/issues/62)
          * and [here](https://github.com/lcscs/lcscs.contracts/issues/61).
          */
         [[lcscs::action]]
         void open( const name& owner, const symbol& symbol, const name& ram_payer );

         /**
          * This action is the opposite for open, it closes the account `owner`
          * for token `symbol`.
          *
          * @param owner - the owner account to execute the close action for,
          * @param symbol - the symbol of the token to execute the close action for.
          *
          * @pre The pair of owner plus symbol has to exist otherwise no action is executed,
          * @pre If the pair of owner plus symbol exists, the balance has to be zero.
          */
         [[lcscs::action]]
         void close( const name& owner, const symbol& symbol );

         [[lcscs::action]]
         void addneedmsign( const name& owner);

         [[lcscs::action]]
         void remneedmsign( const name& owner);

         static asset get_supply( const name& token_contract_account, const symbol_code& sym_code )
         {
            stats statstable( token_contract_account, sym_code.raw() );
            const auto& st = statstable.get( sym_code.raw() );
            return st.supply;
         }

         static asset get_balance( const name& token_contract_account, const name& owner, const symbol_code& sym_code )
         {
            accounts accountstable( token_contract_account, owner.value );
            const auto& ac = accountstable.get( sym_code.raw() );
            return ac.balance;
         }

         using create_action = lcscs::action_wrapper<"create"_n, &token::create>;
         using issue_action = lcscs::action_wrapper<"issue"_n, &token::issue>;
         using retire_action = lcscs::action_wrapper<"retire"_n, &token::retire>;
         using transfer_action = lcscs::action_wrapper<"transfer"_n, &token::transfer>;
         using open_action = lcscs::action_wrapper<"open"_n, &token::open>;
         using close_action = lcscs::action_wrapper<"close"_n, &token::close>;
      private:
         struct [[lcscs::table]] account {
            asset    balance;

            uint64_t primary_key()const { return balance.symbol.code().raw(); }
         };

         struct [[lcscs::table]] currency_stats {
            asset    supply;
            asset    max_supply;
            name     issuer;

            uint64_t primary_key()const { return supply.symbol.code().raw(); }
         };

         struct [[lcscs::table]] needmoresign {
            name     owner;

            uint64_t primary_key()const { return owner.value; }
         };

         typedef lcscs::multi_index< "accounts"_n, account > accounts;
         typedef lcscs::multi_index< "stat"_n, currency_stats > stats;
         typedef lcscs::multi_index< "needmoresign"_n, needmoresign > need_more_sign_table;

         void sub_balance( const name& owner, const asset& value );
         void add_balance( const name& owner, const asset& value, const name& ram_payer );
         bool is_need_more_sign( const name& account );
   };

}
