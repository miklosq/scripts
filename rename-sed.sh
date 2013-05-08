ls file* | sed 's/\(.*\)\.txt\(.*\)/mv & \1\2\.csv/' | sh
