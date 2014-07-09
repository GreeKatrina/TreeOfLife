Tree of Life
==========

tol.herokuapp.com

Tree of Life is a data visualization app that allows people to click through a dynamic tree, built with Infovis - a Javascript toolkit, using data from the Tree of Life API.

## Authors

Katrina Theodosopoulos
+ Email: katrinaelaine6@mgail.com
+ Twitter: http://twitter.com/greekatrina
+ GitHub: https://github.com/greekatrina

Ashley McKemie
+ Email: ashley.mckemie@mgail.com
+ Twitter: http://twitter.com/amckemie
+ GitHub: https://github.com/amckemie

## Development

+ Ruby 2.1.1
+ Sinatra
+ ActiveRecord
+ PostgreSQL
+ WikiWhat
+ Infovis (JIT)
+ Postman
+ JSON / XML

## Access our API

We plan to change our API so that it can accessible by the species name, but you must access it by id as of now.
The API returns a JSON object that includes the node of the species you requested and all of it's first children.

To get the 'homo' node, which includes humans (homo sapiens), you would make an AJAX call to this:

http://tol.herokuapp.com/node-attributes?id=16418

The JSON you would get back:

```
{
    "success?": true,
    "species": {
        "name": "Homo",
        "id": 16418,
        "parent_id": 16416,
        "phylesis": 0,
        "extinct": false,
        "leaf": false,
        "data": {},
        "children": [
            {
                "name": "Homo sapiens",
                "id": 16421,
                "parent_id": 16418,
                "phylesis": 0,
                "extinct": false,
                "leaf": true,
                "data": {}
            },
            {
                "name": "Homo erectus",
                "id": 16422,
                "parent_id": 16418,
                "phylesis": 0,
                "extinct": true,
                "leaf": true,
                "data": {}
            },
            {
                "name": "Homo ergaster",
                "id": 16423,
                "parent_id": 16418,
                "phylesis": 0,
                "extinct": true,
                "leaf": true,
                "data": {}
            },
            {
                "name": "Homo rudolfensis",
                "id": 16424,
                "parent_id": 16418,
                "phylesis": 0,
                "extinct": true,
                "leaf": true,
                "data": {}
            },
            {
                "name": "Homo habilis",
                "id": 16425,
                "parent_id": 16418,
                "phylesis": 0,
                "extinct": true,
                "leaf": true,
                "data": {}
            }
        ]
    },
    "wiki": {
        "title": "Homo",
        "paragraphs": [
            "<p><i><b>Homo</b></i> is the genus of hominids that includes modern humans and species closely related to them. The genus is estimated to be about 2.3 to 2.4 million years old, possibly having evolved from australopithecine ancestors, with the appearance of <i>Homo habilis</i>. Several species, including <i>Australopithecus garhi</i>, <i>Australopithecus sediba</i>, <i>Australopithecus africanus</i>, and <i>Australopithecus afarensis</i>, have been proposed as the direct ancestor of the <i>Homo</i> lineage. These species have morphological features that align them with <i>Homo</i>, but there is no consensus on which gave rise to <i>Homo</i>, assuming it was not an, as yet, undiscovered species.</p>"
        ]
    },
    "wiki_sidebar": "http://upload.wikimedia.org/wikipedia/commons/c/cd/Homo_Models.JPG"
}
```

The id numbers start at 1 with 'Life on Earth', and up to around 70,800.

"phylesis" - will be either 0 - monophyletic, 1 - monophyly uncertain, or 2 - not monophyletic
More information on monophyly: https://www.mun.ca/biology/scarr/Taxon_types.htm

"extinct" - will be true or false

"leaf" - will be either true - it represents a leaf (no child nodes) or false - it does not represent a leaf (will have child nodes).
More information on leaf nodes: https://www.princeton.edu/~achaney/tmve/wiki100k/docs/Leaf_node.html

"data" - this was used for infovis to store data to edit the css for each node. This will always be an empty object.

"wiki" - an object that includes the title and first paragraph from Wikipedia's website that we grabbed using https://github.com/BonMatts/wikiwhat.

"wiki_sidebar" - the url for the image that Wikipedia has on their site for that node.

The original API came from tolweb.org. We converted it from XML to JSON.

## Future Goals

+ Use D3 instead of Infovis
+ Make calls to API faster
+ Make it possible to get species by name
+ Fix null nodes (Common Ancestors)
+ Make app not display Wikipedia info for things that are not species (ex: 'Node 1' is actually part of the International Space Station)
+ Create more RESTful api
