# takes 3 csv files; movies.csv, tags.csv and links.csv
# merges them for further data inspection
# replace na values with a defined value

require(data.table)

# Movie Ids

# Only movies with at least one rating or tag are included in the dataset
# These movie ids are consistent with those used on the MovieLens web site (e.g., id `1` corresponds to the URL <https://movielens.org/movies/1>)
# Movie ids are consistent between `ratings.csv`, `tags.csv`, `movies.csv`, and `links.csv`
# (i.e., the same id refers to the same movie across these four data files).

movies <- fread('movies.csv')

tag_columns <- c('movieId', 'tag')
tags <- fread('tags.csv', select = tag_columns)

link_columns = c('movieId', 'imdbId')
link <- fread('links.csv', select = link_columns)
head(link)

#---------------------------#
# merge - data table method #
#---------------------------#

movies_tags <- merge(movies, tags, by = 'movieId', all.x = TRUE)

movies_tags_links <- merge(link, movies_tags, by = 'movieId', all.x = TRUE)

# remove the movies, tags and link objects
rm(list = c('movies','tags', 'link'))

#-----------------------------------------------------#
# count all the missing data in the merged data.table #
#-----------------------------------------------------#

colSums(is.na(movies_tags_links))

#-------------------------------------------------------#
# count missing data in a single column - base R method #
#-------------------------------------------------------#

sum(is.na(movies_tags_links$tag))

# gsub on a single dataframe column - base R
# pipe delimits each genre in the genre column
# replace the pipe with space

movies_tags_links$genres <- (lapply(movies_tags_links$genres, gsub, pattern="\\|", replacement=" "))
head(movies_tags_links)

#----------------------------------------------------------------------#
# replace Na in the tag column with "no tag given" - data table method #
#----------------------------------------------------------------------#

movies_tags_links[is.na(tag), tag := 'no tag']
head(movies_tags_links)
class(movies_tags_links)
