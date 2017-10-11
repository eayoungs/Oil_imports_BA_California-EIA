For a rendering of the data visualization, see the project page at https://eayoungs.github.io/Oil_imports_BA_California-EIA/

# Environmental Impacts of Oil Imports to Bay Area Refineries

This project is a data visualization of the flows of oil from around the world to refineries in the San Francisco Bay Area.
The intent is to make the changes in carbon emissions related to the various crude oil grades from each country of import and
compare that to the changes in air polutants regulated by the Bay Area Air Quality Manangement Board (BAAQMD).

The thesis, based on scientific papers, commissioned by BAAQMD itself, from the [Union of Concerned Scientists](http://www.ucsusa.org/sites/default/files/legacy/assets/documents/global_warming/oil-refinery-CO2-performance.pdf)    and the staff's
own proposed [rule 12-16](http://www.baaqmd.gov/~/media/files/planning-and-research/rules-and-regs/workshops/2015/1215-1216-workshop/1215_1216_fs_022715.pdf)
                         , is that the driving factors for carbon emissions are separate and independent of those that produce
other air pollutants known as [criteria air pollutants (CAP)](
                                              http://www.baaqmd.gov/research-and-data/emission-inventory/criteria-air-pollutantsk)
                                                             [and toxic air contaminants](
                                                                              http://www.baaqmd.gov/research-and-data/air-toxics).

## Getting Started

The primary data sources for data in this project are from the [Energy Information Administration](https://tinyurl.com/y9md3g79)
and the [California Air Resources Board](https://www.arb.ca.gov/app/emsinv/facinfo/facinfo.php).

### Prerequisites

The data was reformed according to the tenents of [Tidy Data](
                                                          https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
                                                             , which essentially reforms the as table in a data frame. This
allows the use of SQL queries on the data frame, thereby reducing the confusion and messiness of operating. The simple query
shown below, for example was used to get all of the variables used in the Sankey diagram that can be seen on the project page.
(link at the top of this page)

```sql
SELECT origin_var, destination_var, dat_var AS BARRELS FROM imports
WHERE NOT origin_var='World' AND years_var='2009' AND destination_var IN
  ('CHEVRON USA / RICHMOND / CA',
  'PHILLIPS 66 CO / SAN FRANCISCO / CA',
  'VALERO REFINING CO CALIFORNIA / BENICIA / CA',
  'SHELL OIL PRODUCTS US / MARTINEZ / CA',
  'TESORO CORP / GOLDEN EAGLE / CA')
  GROUP BY 1,2
```

<!--
### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
-->
