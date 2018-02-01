#########################################################################
# File Name: get_publisher_info.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Mon 15 Jun 2015 01:42:23 PM CST
#########################################################################
#!/bin/bash


#Field Name
#PMID	First Author	Affiliation	Title	Journal	Date	Doi	Abstract

ID=$1
if [ "$ID" == '' ];then
	echo "***Please input pubmed id***"
	exit 1
fi


efetch -db pubmed -id $ID -format xml |\
	xtract -pattern PubmedArticle -element MedlineCitation/PMID \
	-block AuthorList -first LastName AffiliationInfo/Affiliation \
	-block Article -element ArticleTitle \
	-block Journal -element ISOAbbreviation \
	-block PubDate -sep ' ' -element Month,Year \
	-block ArticleId -match ArticleId@IdType:doi -element ArticleId \
	-block Abstract -element AbstractText




