if [ "$1" = "" ]
then
  echo "Usage: $0 <number_of_files> <dir_name> <file_size_in_kb>"
  exit
fi

end=$1
dir=$2
size=$3
i=0
mkdir $2; 
echo "Creating $end files of size $3kb in directory $2"
while [ $i -lt $end ]
  do
  echo $i
  `dd if=/dev/zero of=$2/file.$2.$i count=1 bs=${size}k >& /dev/null`
  i=`expr $i + 1`
done
