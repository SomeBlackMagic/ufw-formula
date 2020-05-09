{%- if (pillar['ufw']['applications'] is defined) and (pillar['ufw']['applications'] is not none) %}
apply_ufw_fixes:
  ufw.manage_records:
    - name: "foo"
    - records: {{ pillar['ufw']['applications'] | yaml }}
{%- endif %}
