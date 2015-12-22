import os
import re
from fabric.api import run, cd, env, lcd, sudo, put, local
from fabric.contrib.project import rsync_project
from fabric.operations import prompt


local_app_dir = os.getcwd() + os.sep
remote_app_dir = '/root/docker/rabas/code'
docker_dir = '/root/docker/rabas'

# gitignore pattern
pattern = r"^(?P<file>[\w\s\d\.\*,/_\[\]]*)(#|.)*$"
regex = re.compile(pattern)


def docker():
    env.hosts = ['5.200.33.200']
    env.user = 'root'

def deploy():
    exclude = ["fabfile.py"]
    with open(".gitignore", "r") as f:
        for line in f.readlines():
            match = regex.match(line)
            if match:
                _file = match.group('file').strip()
                if _file:
                    exclude.append(_file)
    rsync_project(
        local_dir=local_app_dir,
        remote_dir=remote_app_dir, 
        exclude=exclude,
        delete=True,
    )

def build():
    run("cd %s; docker-compose build; docker-compose up -d" % docker_dir)
