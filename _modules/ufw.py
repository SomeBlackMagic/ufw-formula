"""
Execution module for UFW.
"""

import gettext
import os

import ufw.frontend
import ufw.common
import ufw.parser
import ufw.util


def _init_gettext():
  progName = ufw.common.programName
  gettext.install(progName)  # fixes '_' not defined


_init_gettext()

def _run_rule(rule_str, force=True):

    _init_gettext()

    p = ufw.parser.UFWParser()

    # Rule commands
    for i in ['allow', 'limit', 'deny', 'reject', 'insert', 'delete']:
        p.register_command(ufw.parser.UFWCommandRule(i))
        p.register_command(ufw.parser.UFWCommandRouteRule(i))

    pr = p.parse_command(rule_str.split(' '))

    rule = pr.data.get('rule', '')
    ip_type = pr.data.get('iptype', '')

    return frontend.do_action(pr.action, rule, ip_type, force)

#################################################################################
def is_enabled():

    out = __salt__['cmd.run'](cmd, python_shell=True)
    return True if out else False

def get_default_incoming():
    cmd = 'ufw status verbose | grep "Default:"'
    out = __salt__['cmd.run'](cmd, python_shell=True)
    policy = re.search('(\w+) \(incoming\)', out).group(1)
    return policy

def get_default_outgoing():
    cmd = 'ufw status verbose | grep "Default:"'
    out = __salt__['cmd.run'](cmd, python_shell=True)
    policy = re.search('(\w+) \(outgoing\)', out).group(1)
    return policy

def set_enabled(enabled):
    if __opts__['test']:
        cmd = "ufw --dry-run "
    else:
        cmd = "ufw "
    cmd += '--force enable' if enabled else 'disable'
    __salt__['cmd.run'](cmd)

def add_rule(rule):
    if __opts__['test']:
        cmd = "ufw --dry-run "
    else:
        cmd = "ufw "
    cmd += rule
    out = __salt__['cmd.run'](cmd, python_shell=True)
    return out
