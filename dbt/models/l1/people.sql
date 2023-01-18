{{
    config(
        materialized='incremental'
    )
}}
select p.tenant,
       p.party_id,
       pp.party_person_type,
       pi2.first_name,
       pi2.last_name,
       p.avatar_url,
       pi2.gender,
       greatest(lower(p.sys_period), lower(pp.sys_period)) as updated_ts

from {{source('core', 'party')}}  p
         join {{source('core', 'party_person')}} pp on p.tenant = pp.tenant and p.party_id = pp.party_id
         join {{source('core', 'personal_information')}} pi2
              on pi2.tenant = pp.tenant and pi2.personal_information_id = pp.personal_information_id


 {{ incremental_filter(['p', 'pp', 'pi2'], true) }}

