#pragma once

#include <lcscs/lcscs.hpp>
#include <lcscs/time.hpp>

namespace tracecontract
{
    using lcscs::microseconds;
    using lcscs::time_point;
    using lcscs::name;
    using lcscs::const_mem_fun;
    using lcscs::permission_level;
    using lcscs::action;
    using lcscs::require_auth;
    using lcscs::check;
    using lcscs::datastream;
    using lcscs::indexed_by;
    using lcscs::unsigned_int;
    using lcscs::checksum256;


    // 商品基础信息表结构
    struct [[lcscs::table, lcscs::contract("lcscs.trace")]] base_data {
      uint64_t id;                              // id （自增）
      std::string udid;                         // 识别码
      lcscs::checksum256 udid_hash;             // 识别码hash
      std::string brand;                        // 品牌
      std::string product_name;                 // 商品名称
      std::string factory_name;                 // 厂名
      std::string factory_address;              // 厂址
      std::string factory_number;               // 厂家联系方式
      std::string production_license_number;    // 生产许可证编号
      std::string json_data;                    // 商品属性(json格式)

      uint64_t primary_key()const { return id; }
      lcscs::checksum256 second_key() const { return udid_hash; }

    };
    // 商品基础信息表  
    typedef lcscs::multi_index< "basedata"_n, base_data, lcscs::indexed_by<"bysubkey"_n, 
      lcscs::const_mem_fun<base_data, lcscs::checksum256, &base_data::second_key>>> base_data_table;


    // 单次识别信息表结构
    struct per_identify_data {
      int32_t identify_count;           // 识别次数
      std::string identify_ip;          // 识别ip
      std::string identify_location;    // 识别位置
      std::string identify_time;        // 识别时间
      uint8_t is_transregional;            // 是否跨地区
      std::string buy_area;             // 购买区域
    };

    // 商品识别信息溯源表结构
    struct [[lcscs::table, lcscs::contract("lcscs.trace")]] identify_data {
      uint64_t id;                              // 自增
      std::string udid;                         // 识别码
      lcscs::checksum256 udid_hash;             // 识别码hash
      uint8_t identify_total_count;             // 识别总次数 
      std::vector<per_identify_data> per_identify_datas;       //单次识别信息

      uint64_t primary_key()const { return id; }
      lcscs::checksum256 second_key() const { return udid_hash; }

    };
    // 商品识别信息溯源表
    typedef lcscs::multi_index< "identifydata"_n, identify_data, lcscs::indexed_by<"bysubkey"_n, 
      lcscs::const_mem_fun<identify_data, lcscs::checksum256, &identify_data::second_key>>> identify_data_table; 

   class [[lcscs::contract("lcscs.trace")]] trace_contract : public lcscs::contract
   {
      public:
        using lcscs::contract::contract;

        ACTION addbasedata(std::string& udid, std::string& brand, std::string& product_name, std::string& factory_name, std::string& factory_address, std::string& factory_number, std::string& production_license_number, std::string& json_data); 
        ACTION addidfydata(std::string& udid, std::string& identify_ip, std::string& identify_location, std::string& identify_time, uint8_t& is_transregional, std::string& buy_area);
        ACTION rmdata(std::string& udid);
             
   };
}

