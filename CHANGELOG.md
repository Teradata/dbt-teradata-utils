## teradata_utils 0.1.0

### Features
* Added tests and/or implementations for the following `dbt_utils` macros:
  * get_url_host
  * get_url_path
  * current_timestamp
  * date_trunc
  * last_day
  * width_bucket
  * pretty_time
  * pretty_log_format

### Fixes
* `split_part` now correctly detects single character delimiters by distinguishing between literals and column names.
* `dateadd` can now take both date literals and date types. Before version 0.1.0, it supported only date types and not literals which was not aligned with the interface defined by dbt_utils. 
* `datediff` can now take both date literals and date types. Before version 0.1.0, it supported only date types and not literals which was not aligned with the interface defined by dbt_utils. 

### Docs

### Under the hood

---
## teradata_utils 0.0.2

### Features
* Added tests and/or implementations for the following `dbt_utils` macros:
  * pivot
  * unpivot
  * get_url_parameter               
* Added support for multi-character delimiters in `split_part` macro. 

### Fixes

### Docs

### Under the hood

---
## teradata_utils 0.0.1

### Features
* initial release that covers the following `dbt_utils` macros:
  * equal_rowcount         
  * fewer_rows_than        
  * equality               
  * expression_is_true     
  * recency                
  * at_least_one           
  * not_constant           
  * cardinality_equality   
  * not_null_proportion          
  * not_accepted_values          
  * relationships_where          
  * mutually_exclusive_ranges    
  * sequential_values            
  * unique_combination_of_columns
  * accepted_range               
  * get_column_values            
  * get_relations_by_pattern     
  * get_relations_by_prefix      
  * get_query_results_as_dict    
  * date_spine                   
  * haversine_distance           
  * group_by                     
  * star                         
  * union_relations              
  * generate_series              
  * surrogate_key                
  * safe_add                     


### Fixes

### Docs
* Initial documentation

### Under the hood
* Added tests
