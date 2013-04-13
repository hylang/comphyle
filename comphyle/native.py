#XXX: We need to move shit out of here.

from contextlib import contextmanager


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
