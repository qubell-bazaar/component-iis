import os

from test_runner import BaseComponentTestCase
from qubell.api.private.testing import instance, environment, workflow, values

@environment({
    "default": {},
})
class IISComponentTestCase(BaseComponentTestCase):
    name = "component-iis"
    apps = [{
        "name": name,
        "file": os.path.realpath(os.path.join(os.path.dirname(__file__), '../%s.yml' % name))
    }]
    @classmethod
    def timeout(cls):
        return 40

    @instance(byApplication=name)
    @workflow("IIS.pool", {"pool-name": "test-pool", "pool-properties": "{'action':'add'}"})
    @workflow("IIS.site", {"site-name": "test-site", "site-properties": "{'action':['add','start'],'application_pool':'test-pool', 'bindings':'http://*:80'}"})
    @values({"IIS.server-ip": "hosts"})
    def test_port(self, instance, hosts):
        import socket

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((hosts, 80))

        assert result == 0
