{% if (pillar['ufw'] is defined) and (pillar['ufw'] is not none) %}
  {%- if (pillar['ufw']['enabled'] is defined) and (pillar['ufw']['enabled'] is not none) and (pillar['ufw']['enabled']) %}

    # managed nat or custom rules
    {%- if
           (
             (pillar['ufw']['nat'] is defined) and (pillar['ufw']['nat'] is not none) and
             (pillar['ufw']['nat']['enabled'] is defined) and (pillar['ufw']['nat']['enabled'] is not none) and (pillar['ufw']['nat']['enabled'])
           )
           or
           (
             (pillar['ufw']['custom'] is defined) and (pillar['ufw']['custom'] is not none)
           )
    %}

ufw_before_rules_apply:
  file.managed:
    - name: '/etc/ufw/before.rules'
    - source: 'salt://ufw/files/before.rules'
    - mode: 0640
    - template: jinja
    - defaults:
      {%- if
             (pillar['ufw']['nat'] is defined) and (pillar['ufw']['nat'] is not none) and
             (pillar['ufw']['nat']['enabled'] is defined) and (pillar['ufw']['nat']['enabled'] is not none) and (pillar['ufw']['nat']['enabled'])
      %}

        {%- if (pillar['ufw']['nat']['masquerade'] is defined) and (pillar['ufw']['nat']['masquerade'] is not none) %}
        masquerade: {{ pillar['ufw']['nat']['masquerade'] }}
        {%- else %}
        masquerade: ''
        {%- endif %}

        {%- if (pillar['ufw']['nat']['dnat'] is defined) and (pillar['ufw']['nat']['dnat'] is not none) %}
        dnat: {{ pillar['ufw']['nat']['dnat'] }}
        {%- else %}
        dnat: ''
        {%- endif %}

        {%- if (pillar['ufw']['nat']['snat'] is defined) and (pillar['ufw']['nat']['snat'] is not none) %}
        snat: {{ pillar['ufw']['nat']['snat'] }}
        {%- else %}
        snat: ''
        {%- endif %}

        {%- if (pillar['ufw']['nat']['redirect'] is defined) and (pillar['ufw']['nat']['redirect'] is not none) %}
        redirect: {{ pillar['ufw']['nat']['redirect'] }}
        {%- else %}
        redirect: ''
        {%- endif %}

      {%- else %}
        masquerade: ''
        dnat: ''
        snat: ''
        redirect: ''
      {%- endif %}

      {%- if (pillar['ufw']['custom'] is defined) and (pillar['ufw']['custom'] is not none) %}
        {%- if (pillar['ufw']['custom']['nat'] is defined) and (pillar['ufw']['custom']['nat'] is not none) %}
        custom_nat: {{ pillar['ufw']['custom']['nat'] | yaml_encode }}
        {%- else %}
        custom_nat: '# empty'
        {%- endif %}
      {%- else %}
        custom_nat: '# empty'
      {%- endif %}

      {%- if (pillar['ufw']['custom'] is defined) and (pillar['ufw']['custom'] is not none) %}
        {%- if (pillar['ufw']['custom']['filter'] is defined) and (pillar['ufw']['custom']['filter'] is not none) %}
        custom_filter: {{ pillar['ufw']['custom']['filter'] | yaml_encode }}
        {%- else %}
        custom_filter: '# empty'
        {%- endif %}
      {%- else %}
        custom_filter: '# empty'
      {%- endif %}

    {%- endif %}

  {%- endif %}
{% endif %}
