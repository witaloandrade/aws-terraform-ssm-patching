[![git_capa](./img/git_capa.jpg)](https://www.youtube.com/channel/UCKNbFi55znAEztGwHzrVfCw)

## SSM Patch Update Module

This modules was forked from [terraform-aws-ssm-patch-management](https://github.com/claranet/terraform-aws-ssm-patch-management) and changed as needed.  

This module was created to set up some update policies on SSM. The main ideia is that will will create the policies and the SysAdmin just have to set up the TAG's and the instances will be updated pe schedule.  

There will be 3 patch baselines that will approve updates after they are 7,15 and 30 days old from published.  

The schedule will apply the updates every Wednesday and  Saturday at 02:00AM.  
Updates will be applied as approved from 7,15 and 30 days.  

### Tags Names:

- "${var.vendor}-${var.osystem}-CU7D-PG1"
- "${var.vendor}-${var.osystem}-CU7D-PG2"
- "${var.vendor}-${var.osystem}-CU15D-PG1"
- "${var.vendor}-${var.osystem}-CU15D-PG2"
- "${var.vendor}-${var.osystem}-CU30D-PG1"
- "${var.vendor}-${var.osystem}-CU30D-PG2"




This modules was forked from [terraform-aws-ssm-patch-management](https://github.com/claranet/terraform-aws-ssm-patch-management) and changed as needed.  

There is some improves needed and they will be done asap.  