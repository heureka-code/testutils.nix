import os
import sys
import subprocess

operation = sys.argv[2] if len(sys.argv) > 2 else ""

count_repos = 0

if len(sys.argv) == 1:
    print("Usage: DIRNAME and then 'list', 'remove' or 'create'")
    exit(0)

PATH = sys.argv[1]
BUNDLE_CMD_ARGS = ["git", "bundle", "create", "git.bundle", "--all"]

if operation == "create":
    for root, dirs, _ in os.walk(PATH):
        if ".git" in dirs:
            print("Create bundle for:", root)
            subprocess.run(BUNDLE_CMD_ARGS, cwd=root)
            count_repos += 1
elif operation == "remove":
    for root, dirs, files in os.walk(PATH):
        if "git.bundle" in files and ".git" not in dirs:
            print(f"[WARN] keep git.bundle in {root} as no .git dir is found")
        elif "git.bundle" in files:
            print("Remove bundle for:", root)
            os.remove(os.path.join(root, "git.bundle"))
            count_repos += 1
elif operation == "list":
    for root, dirs, _ in os.walk(PATH):
        if ".git" in dirs:
            print("No op:", root)
            count_repos += 1
else:
    print("Usage: DIRNAME and then 'list', 'remove' or 'create'")
    exit(0)
print(f"Operated on {count_repos} repositories")
