apply_ufw_fixes:
  ufw.manage_records:
    - records: {{ zone_item | yaml }}
