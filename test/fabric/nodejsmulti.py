import re
from fabric.api import env, run, hide, task
from envassert import detect, file, group, package, port, process, service, \
    user, text


def apache2_is_responding():
    with hide('running', 'stdout'):
        wget_cmd = (
            "wget --quiet --output-document - --header='Host: example.com' "
            "http://localhost/"
        )
        homepage = run(wget_cmd)
        if re.search('Welcome to example.com', homepage):
            return True
        else:
            return False


@task
def check():
    env.platform_family = detect.detect()

    config_js = '/var/app/current/config.js'
    assert file.exists(config_js), \
        "%s does not exist" % config_js
    assert file_contains(config_js, 'StrictHostKeyChecking false'), \
        "%s does not turn off StrictHostKeyChecking" % config_js

    dot_npm = "/home/my_nodejs_app/.npm"
    assert file.exists(dot_npm), \
        "%s does not exist" % dot_npm
    assert file.is_dir(dot_npm), \
        "%s is not a directory" % dot_npm
    assert file.is_mode(dot_npm, 'r-xr-xr-x'), \
        "%s is not mode 755" % dot_npm
    assert file.owner_is(dot_npm, 'my_nodejs_app'), \
        "%s is not owned by my_nodejs_app" % dot_npm
    # directory { should be_grouped_into 'my_nodejs_app' }

    assert port.is_listening(80), "port 80/apache2 is not listening"

    assert user.exists("my_nodejs_app"), "user my_nodejs_app does not exist"
    assert user_has_shell('my_nodejs_app', ':/bin/bash'), \
        "user should have bash shell"

    assert process.is_up("node"), "node process is not up"
    # its('args') { should match 'server.js|app.js' }

    assert service.is_enabled("my_nodejs_app"), \
        "my_nodejs_app service is not enabled"

    assert apache2_is_responding(), "node demo app did not respond as expected"


def user_has_shell(uname, sname):
    fname = '/etc/passwd'
    user_line = file_find(fname, uname)
    if not user_line:
        return False

    return sname in user_line


def file_contains(fname, txt):
    with open(fname) as dataf:
        return any(txt in line for line in dataf)
    return False


def file_find(fname, txt):
    with open(fname) as dataf:
        for line in dataf:
            if txt in line:
                return txt
