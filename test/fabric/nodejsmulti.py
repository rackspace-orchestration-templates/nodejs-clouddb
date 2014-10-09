import re
from fabric.api import env, run, hide, task
from envassert import detect, file, group, package, port, process, service, \
    user, text


def nodejs_is_responding():
    with hide('running', 'stdout'):
        wget_cmd = (
            "wget --quiet --output-document - --header='Host: example.com' "
            "http://localhost/"
        )
        homepage = run(wget_cmd)
        if re.search('This is the landing page', homepage):
            return True
        else:
            return False


@task
def check():
    env.platform_family = detect.detect()

    dot_npm = "/home/user1/.npm"
    assert file.exists(dot_npm), \
        "%s does not exist" % dot_npm
    assert file.is_dir(dot_npm), \
        "%s is not a directory" % dot_npm
    assert file.mode_is(dot_npm, '755'), \
        "%s is not mode 755" % dot_npm
    assert file.owner_is(dot_npm, 'user1'), \
        "%s is not owned by user1" % dot_npm
    # directory { should be_grouped_into 'my_nodejs_app' }

    assert port.is_listening(80), "port 80/apache2 is not listening"

    assert user.exists("user1"), "user my_nodejs_app does not exist"

    assert process.is_up("node"), "node process is not up"
    # its('args') { should match 'server.js|app.js' }

    assert service.is_enabled("node-app"), \
        "node-app service is not enabled"

    assert nodejs_is_responding(), "node demo app did not respond as expected"
