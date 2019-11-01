#!/bin/bash
#
# Checks if required dirs or files are found or exits with an error

REQUIRED_DIRS=(
  "code/"
  "data/"
  "LOG/"
  "reports/"
  "resources/img/"
  "results/" 
)

REQUIRED_GUIDE_FILE=(
  "README.md"
)

REQUIRED_EXECUTABLE_FILES=(
  "bbduk.sh"
  "fastqc"
  "mothur"
  "multiqc"
  "seqkit"
  "uchime"
  "vsearch"
  )

REQUIRED_CODE_FOLDERS_OR_FILES=(
# "01_metadataProfiling_driver.bash"
# "02_readPreprocess_driver.bash"
# "03_imapClassifyOTU_driver.bash"
# "04_OTUanalysis_driver.bash"
# "bbmap"
# "css"
# "dataanalysis"
# "datatransformation.bash"
# "dockerImages.sh"
# "imapOTUanalysisReport_driver.bash"
# "otutaxonomy"
""
""
"installSoftware"
"checkFoldersFiles"
"dataFiles"
"preprocessing"
# "progressreport1.bash"
# "progressreport2.bash"
# "progressreport3.bash"
# "progressreport4.bash"
# "qiime2"
"refdatabase"
# "requirements"
"Rmd"
"seqclassification"
"seqerrorrate"
"seqprocessing"
# "splitlefse.pl"
# "summarizeFastQC"
)

REQUIRED_DATA_FOLDERS=(  
  "metadata/*"
  # "mothur/"
  # "qiime2/"
  "raw/*.gz"
  "references/*"
)

REQUIRED_REFERENCES_FILES=(
  # Ref alignments (mothur)
  "silva.seed.align"  
  # Classifiers (mothur)
  "HMP_MOCK.fasta"
  "silva.seed.align"
  "silva.seed.ng.fasta"
  "silva.seed.tax"
  # Classifiers (mothur)QIIME2
  ""
)

REQUIRED_METADATA_FILES=(
  "var1.design"
  "var2.design"
  "var3.design"
  "var4.design"
  "samplemetadata.tsv"
  # "samplemetadata_casestudy.txt"
  "qced.files"
  "manifest.txt"
  # "186samples.metadata"
)


# adds a line break after a comment
begin_comment() {
  echo "" 
  echo "$1"
  echo ""
}

# adds a line break before a comment
end_comment(){
  echo ""
  echo "$1"
  echo ""
}

is_file(){
 [ -s $1 ]
}

is_dir(){
 if [ -d $1 ]; then
   [ "$(ls -A $1)" ] && return 0 || return 1
 else
   return 1
 fi
}

is_symlink(){
 [ -h $1 ]
}

check_required_dirs(){
  local did_pass=true
  local name=$1[@]
  local dirs=("${!name}")

  for Path in "${dirs[@]}"
  do
    if is_dir $Path; then
      echo "✅ [${Path}] found"
    else 
      echo "❌ [${Path}] is required"
      did_pass=false
    fi
  done

  if !($did_pass); then
    end_comment "Sorry, exiting.. missing required directories, please fix. "
    exit 1
  fi
  echo ""
}

check_dir_files(){
  local dir=$1
  local name=$2[@]
  local files=("${!name}")

  if !(is_dir $dir); then
    end_comment "exiting.. [$dir] directory is not found"
    exit 1
  fi
 
  begin_comment "Checking for valid folders or files in [$dir] directory"

  for File in "${files[@]}"
  do
    if is_file $dir/$File; then
      echo "✅ [${File}] found"
    else 
      echo "❌ [${File}] is required"
      did_pass=false
    fi
  done

  if !($did_pass); then
    end_comment "Sorry, exiting.. missing required file(s). Please review and fix. "
    exit 1
  fi
  echo ""



  # if !($did_pass); then
  #   end_comment "exiting.. missing required files. "
  #   exit 1
  # fi
}

### Main Script Starts Here

# begin_comment "Checking if you have the required directories and files."

# check required folders in [$PWD] directory
check_required_dirs REQUIRED_DIRS

# check required files in [$PWD] directory
check_dir_files $PWD/ REQUIRED_GUIDE_FILE

# check required files in [~/bin] directory
check_dir_files $HOME/bin REQUIRED_EXECUTABLE_FILES

# check required files in [$PWD/code] directory
check_dir_files $PWD/code REQUIRED_CODE_FOLDERS_OR_FILES

# check required files in [$PWD/data] directory
check_dir_files $PWD/data REQUIRED_DATA_FOLDERS

# check required files in [$PWD/data/references] directory
check_dir_files $PWD/data/references REQUIRED_REFERENCES_FILES

# check required files in [$PWD/data/metadata] directory
check_dir_files $PWD/data/metadata REQUIRED_METADATA_FILES

end_comment "✅ HURRAY!! EVERYTHING PASSED!,"