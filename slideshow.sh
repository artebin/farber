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
feh -R 2 "${CURRENT_IMAGE_FILE}" &
FEH_PID=$?

IMAGE_FIFO="flick_images.fifo"
while true; do
	if read IMAGE <"${IMAGE_FIFO}"; then
		cp "${IMAGE}" "${CURRENT_IMAGE_FILE}"
		sleep 1
	fi
done
