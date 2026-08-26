import sys
import subprocess
import time
from pathlib import Path
from threading import Thread
import argparse


def check_only_dirs(args: list[Path]):
    for arg in args:
        if arg.is_dir() and arg.exists():
            continue
        elif not arg.exists():
            print(f"Input path doesn't exist: {arg}", file=sys.stderr)
            sys.exit(11)
        else:
            print(f"Input path is not a directory: {arg}", file=sys.stderr)
            sys.exit(10)


def input_paths_from_stdin():
    print("Read paths from stdin line by line", file=sys.stderr)
    try:
        args = [Path(line.rstrip("\n")) for line in sys.stdin.readlines()]
    except KeyboardInterrupt:
        msg = "Keyboard interrupt while reading paths from stdin"
        print(msg, file=sys.stderr)
        sys.exit(1)
    check_only_dirs(args)
    return args


def touch_file(in_file: Path):
    print(f"Touch {in_file!r}")
    p = "touch"
    exit_code = subprocess.call([p, in_file])  # , executable=p)
    if exit_code != 0:
        print(f"Failed to touch {in_file!r}", file=sys.stderr)


def process_dir(in_path: Path, sleep_duration: float = 0.5):
    print(f"Process all files in directory {in_path.absolute()}")
    for in_file in sorted(in_path.iterdir()):
        if in_file.is_file():
            touch_file(in_file)
            time.sleep(sleep_duration)


def main_sequential(paths: list, *, sleep_duration: float = 0.5):
    for in_path in paths:
        process_dir(in_path, sleep_duration=sleep_duration)


def main_parallel(paths, *, sleep_duration: float = 0.5):
    threads = []
    for in_path in paths:
        thread = Thread(target=process_dir, args=(in_path, sleep_duration))
        thread.start()
        threads.append(thread)
    for t in threads:
        t.join()


parser = argparse.ArgumentParser(
    prog="touch-in-order",
    description="Process files of directory in order and"
    + " update modification time with 'touch'",
)

if __name__ == "__main__":
    parser.add_argument(
        "-p",
        "--parallel",
        help="Use a separate thread for every provided directory",
        action="store_true",
    )
    parser.add_argument(
        "-",
        "--stdin",
        help="Read additional directories line by line from stdin, "
        + "'-' notation can only be used before or after all 'directories'",
        action="store_true",
    )
    parser.add_argument(
        "-s",
        "--sleep",
        help="Sleep time between touching two consecutive files in seconds, "
        + "default=0.5",
        type=float,
        default=0.5,
    )
    parser.add_argument("directories", nargs="*", type=Path)
    args = parser.parse_args()

    paths: list = args.directories
    check_only_dirs(paths)
    if args.stdin:
        paths.extend(input_paths_from_stdin())
    elif len(paths) == 0:
        parser.print_help()
        msg = "No directories in cli arguments and stdin flag not set"
        print(msg, file=sys.stderr)
        sys.exit(2)

    if args.parallel:
        main_parallel(paths, sleep_duration=args.sleep)
    else:
        main_sequential(paths, sleep_duration=args.sleep)
