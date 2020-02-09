#!/usr/bin/env bash

print_section_heading(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	printf "# ${1}\n"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

print_section_ending(){
	echo
	echo
	echo
}

exit_script(){
	exit 1
}

trap exit_script SIGINT SIGTERM

CURRENT_IMAGE_FILE="feh_current_image"
if [[ -f "${CURRENT_IMAGE_FILE}" ]]; then
	rm -f "${CURRENT_IMAGE_FILE}"
fi
cp empty.jpg "${CURRENT_IMAGE_FILE}"
feh -R 5 "${CURRENT_IMAGE_FILE}" &
FEH_PID=$?

while true; do
	IMAGE=$(flock -x FLICKR_IMAGE_LIST head -n 1 FLICKR_IMAGE_LIST)
	if [[ ! -z "${IMAGE}" ]]; then
		flock -x FLICKR_IMAGE_LIST bash -c "tail -n +2 FLICKR_IMAGE_LIST | sponge FLICKR_IMAGE_LIST"
		printf "%s\n" "${IMAGE}"
		cp "${IMAGE}" "${CURRENT_IMAGE_FILE}"
	else
		printf "Cannot retrieve any image\n"
	fi
	sleep 5
done
