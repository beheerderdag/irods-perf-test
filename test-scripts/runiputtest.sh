if [ "$1" = "" ]
then
  echo "Usage: $0 <iput_commands_to_run> <number_of_files> <dir_name> <file_size_in_kb> <out_put_file_name>"
  exit
fi


iput_cmd=$1
file_count=$2
dir_name=$3 
file_size=$4
outputfile_name=$5 


# make the files: 

#maketestfile.sh <number_of_files> <dir_name> <file_size_in_kb>
sh maketestfile.sh $2 $3 $4

#date >> mytest.out ; echo "iput 1000 files test" >> mytest.out ; /usr/bin/time -f "%e" iput -r -b test.1000 2>>mytest.out 

startd=`date`
   echo "--- Timing $iput_cmd of $2 files ---- " 
   echo "--- Timing $iput_cmd of $2 files ---- " >>$outputfile_name
echo "start:  $startd" >>$outputfile_name 
echo "Running $iput_cmd $3...." 

/usr/bin/time -f "%e" $iput_cmd $3 2>>$outputfile_name 

endd=`date`
echo "end:   $endd" >>$outputfile_name 
exit 0
