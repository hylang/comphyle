#XXX: We need to move shit out of here.

from contextlib import contextmanager
from sh import dpkg
import sh


@contextmanager
def cd(path):
    old_dir = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(old_dir)


@contextmanager
def tmpdir():
    path = tempfile.mkdtemp()
    try:
        yield path
    finally:
        pass
    rmdir(path)


@contextmanager
def tmpwork():
    with tmpdir() as tmp_path:
        with cd(tmp_path):
            yield tmp_path



class V(object):

    _opers = ["lt", "le", "eq", "ne", "ge", "gt"]

    def __init__(self, version_string):
        self.version_string = version_string

    def _cmp(self, oper, other):
        if not isinstance(other, V):
            raise TypeError("Stop sucking.")
        if oper not in self._opers:
            raise ValueError("Blow it out 'yer ass")

        try:
            dpkg("--compare-versions", self.version_string,
                 oper, other.version_string)
            return True
        except sh.ErrorReturnCode_1:
            return False

    def __lt__(self, other):
        return self._cmp("lt", other)

    def __le__(self, other):
        return self._cmp("lt", other)

    def __eq__(self, other):
        return self._cmp("lt", other)

    def __ne__(self, other):
        return self._cmp("lt", other)

    def __gt__(self, other):
        return self._cmp("lt", other)

    def __ge__(self, other):
        return self._cmp("lt", other)

    def __repr__(self):
        return "<comhyle V - %s>" % (self.version_string)
