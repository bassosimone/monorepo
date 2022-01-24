# Library containing functions

source ./config/lib.bash

get_branch_name() {
	local dirname=$(repo_to_dir $1)
	(cd $dirname && git symbolic-ref --short HEAD)
}

fail_if_dirty() {
	local dirname=$(repo_to_dir $1)
	(cd $dirname && [[ -z $(git status -s) ]] || {
		echo "fatal: $dirname contains modified or untracked files"
		exit 1
	})
}

fail_if_not_main() {
	local dirname=$(repo_to_dir $1)
	(cd $dirname && [[ "$(git symbolic-ref --short -q HEAD)" == "main" ]] || {
		echo "fatal: $dirname is not at the 'main' branch"
		exit 1
	})
}

fail_if_main() {
	local dirname=$(repo_to_dir $1)
	(cd $dirname && [[ "$(git symbolic-ref --short -q HEAD)" != "main" ]] || {
		echo "fatal: $dirname is at the 'main' branch"
		exit 1
	})
}

repo_to_dir() {
	echo repo/$(basename $1)
}

for_each_repo() {
	for repo in ${repositories[@]}; do
		$1 $repo
	done
}
