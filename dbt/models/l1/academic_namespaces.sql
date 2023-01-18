select an.tenant,
       an.academic_namespace_id,
       an."academic_namespace_type",
       an."name",
       an.year,
       c.start_date,
       c.end_date
from {{source('core', 'academic_namespace')}} an
         join {{source('calendar', 'calendar')}} c
on c.tenant = an.tenant and c.academic_namespace_id = an.academic_namespace_id
