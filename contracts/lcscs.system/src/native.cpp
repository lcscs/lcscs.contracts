#include <lcscs.system/native.hpp>

#include <lcscs/check.hpp>

namespace lcscssystem {

   void native::onerror( ignore<uint128_t>, ignore<std::vector<char>> ) {
      lcscs::check( false, "the onerror action cannot be called directly" );
   }

}
