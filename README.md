# DBT_CURSO_DATAENGINER

#About

This is the readme doc about the first proyect in DBT, it's everything in just one branch
even knowing that it's possible and prefered to have so many branchs depending on each
different stage of the proyect, as it could like continues:
-Branch for creating the project
-Branch for Sources
-Branch for Staging/Models
-Branch for Intermediates
-Branch for Marts/Core

As time has been a bit limited is done without branchs as said before.

The proyect is about a company (greenary) that sells via web or direct contac with the users
their own products, most of them plants. I have developed the models and every layer to make
possible work with the data provided by the company in a ,in my opinion, more comfortable way.

#Layers of the proyect.

#Sources
The first stage I started working on was sources, each one (in this case two, google_sheets and
sql_server_dbo) with tests wich controls in every table the data is not corrupted, duplicated,
or in some cases empty.

#Models/Staging
The second layer is staging, this time tests appear less times (it's supposed that data is kind
of controlled in source), but here is where the data start to be modified to be made more queryable.

#Intermediate
The third layer is compossed by tables full of joins between them to get functions and data that
needs to be agrupated to get a clearest info that is going to be used in our marts.

#Marts
Finally we have some data explotation cases (marts) at the end of our proyect where appears all
the archiquecture that our data had at the begining but totally clear (supposed to) and some
tables I created to access data easily.

