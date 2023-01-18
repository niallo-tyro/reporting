{{
    config(
        materialized='incremental'
    )
}}

select
    -- select first subject
    distinct on(p.party_id, s.subject_id)
    p.tenant,
    p.party_id ,
    pian.academic_namespace_id ,
    coalesce (pian.name_override , pg."name") as name,
    greatest(lower(p.sys_period), lower(pg.sys_period),lower(pian.sys_period), lower(sg.sys_period), lower(sgs.sys_period)) as updated_ts,
    ns.start_date,
    ns.end_date,
    s.subject_id, s.name_text_id, s.short_code_text_id


from core.party p
         join {{source('core', 'party_group')}}  pg  on p.tenant = pg.tenant and p.party_id = pg.party_id
         join {{source('core', 'party_in_academic_namespace')}} pian on pian.tenant = p.tenant and pian.party_id  = p .party_id
         join {{source('core', 'subject_group')}} sg on sg.tenant = p.tenant and sg.party_id  = p.party_id
         join {{source('core', 'subject_group_subject')}} sgs on sgs.tenant  = p.tenant and sgs.subject_group_id = sg.party_id
         join {{source('catalogue', 'subject')}} s on s.subject_id = sgs.subject_id
    join {{ref('academic_namespaces')}} ns on ns.tenant = pian.tenant and ns.academic_namespace_id = pian.academic_namespace_id


 {{ incremental_filter(['p', 'pg', 'sg', 'sgs', 's'], true) }}
