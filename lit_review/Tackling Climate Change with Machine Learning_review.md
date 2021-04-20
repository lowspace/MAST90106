# Review of Tackling Climate Change with Machine Learning

## Summary

Topic = survey on how ML can be used in climate change (greenhouse gas emissions) and provide strategies of this event

Finance contains two major subjects, climate investment and climate analytics.

* climate investment = investing money in low-carbon assets
  * methods:
    * construct an index about the environment friendly market;
    * invest high carbon cost company to incentivize them to reduce carbon cost
  * use DL and words well.
* climate analytics = predict the financial effects of climate change
  * model: NLP + econometric + ML

Challenges in this area:

* long, middle, short term effects posed by climate change all affect the financial performance;
* little research focus on this area:
  * in-depth modeling of variables linked to climate risk;
  * designing a statistical climate factor that can be used to project the variation of stock prices given a compound set of events;
  * identifying direct and indirect climate risk exposure in annual company reports.
* data is insufficient: not global (dependency on country or area), not organized well.

Bibtex:

``` latex
@misc{rolnick2019tackling,
      title={Tackling Climate Change with Machine Learning}, 
      author={David Rolnick and Priya L. Donti and Lynn H. Kaack and Kelly Kochanski and Alexandre Lacoste and Kris Sankaran and Andrew Slavin Ross and Nikola Milojevic-Dupont and Natasha Jaques and Anna Waldman-Brown and Alexandra Luccioni and Tegan Maharaj and Evan D. Sherwin and S. Karthik Mukkavilli and Konrad P. Kording and Carla Gomes and Andrew Y. Ng and Demis Hassabis and John C. Platt and Felix Creutzig and Jennifer Chayes and Yoshua Bengio},
      year={2019},
      eprint={1906.05433},
      archivePrefix={arXiv},
      primaryClass={cs.CY}
}
```

## Abstract

**Topic**: describe how machine learning can be a powerful tool in reducing greenhouse gas emissions and helping society adapt to a changing climate

This article is a ML community effort involving different domains.

## Introduction

* the world will face catastrophic consequences unless global **greenhouse gas emissions** are eliminated within thirty years
* two ways to address the problem:
  * mitigation (reducing emissions): requires changes to electricity systems, transportation, buildings, industry, and land use ;
  * adaptation (preparing for unavoidable consequences): requires planning for resilience and disaster management.

## Finance

Background:

* The rise and fall of financial markets is linked to many events;
* Climate change poses a substantial financial risks to global assets measured in the trillions of dollars <sup>[[1]](#ft1)</sup>

Challenges:

* hard to forecast where, how, or when climate change will impact the stock price of a given company, or even the debt of an entire nation;
* financial analysts and investors focus on short-term (quarter or year) prediction, while fails to incentivize the prediction of medium or long-term risks <sup>[[2]](#ft2)</sup>.

### Climate investment

* Climate investment  <sup>[[3]](#ft3)</sup>, the current dominant approach in climate finance, involves investing money in low-carbon assets.
* Two methods implemented by financial institutions to take climate investment:
  * creating “green” financial indexes that focus on low-carbon energy, clean technology, and/or environmental services <sup>[[4]](#ft4)</sup>;
  * designing carbon-neutral investment portfolios that remove or under-weight companies with relatively high carbon footprints <sup>[[5]](#ft5)</sup>.
* The performance: works well in certain sectors of the market (e.g. utilities and energy) towards renewable energy alternative <sup>[[6]](#ft6)</sup>
* Model = deep learning to maximize both the impact and scope of climate investment strategies
  * portfolio selection (based on features of the stocks involved);
  * investment timing (using historical patterns to predict future demand)

### Climate analytics

* *climate analytics*, which aims to predict the financial effects of climate change, and is still gaining momentum in the mainstream financial community
* Climate analytics involves analyzing investment portfolios, funds, and companies in order to pinpoint areas with **heightened risk** due to climate change
* Model:
  * NLP = for identifying climate risks and investment opportunities in disclosures made by companies;
  * econometric approaches = for developing arbitrage strategies;
  * ML approaches = for forecasting the price of carbon in emission exchanges

The future directions:

1. improving existing traditional portfolio optimization approaches;
2. in-depth modeling of variables linked to climate risk;
3. designing a statistical climate factor that can be used to project the variation of stock prices given a compound set of events;
4. identifying direct and indirect climate risk exposure in annual company reports.

## Conclusion

Potential problems:

* data may not be organized well for tasks -> heterogeneous problem;
* data may not be representative of global use cases -> require transfer learning and domain adaptation;
* though many datasets are online, but not enough.

## Reference 

<a name="ft1">[1]</a>: SimonDietz,AlexBowen,CharlieDixon,andPhilipGradwell.’climatevalueatrisk’ofglobalfinancialassets. Nature Climate Change, 6(7):676, 2016.

<a name="ft2">[2]</a>: Soliman Abdel-hady Soliman and Ahmad Mohammad Al-Kandari. Electrical load forecasting: modeling and model construction. Elsevier, 2010.

<a name="ft3">[3]</a>: LucEyraud,BenedictClements,andAbdoulWane.Greeninvestment:Trendsanddeterminants.EnergyPolicy, 60:852–865, 2013.

<a name="ft4">[4]</a>: IvanDiaz-Rainey,BeckyRobertson,andCharlieWilson.Strandedresearch?leadingfinancejournalsaresilent on climate change. Climatic Change, 143(1-2):243–260, 2017.

<a name="ft5">[5]</a>: Gianfranco Gianfrate. Designing carbon-neutral investment portfolios. In Designing a Sustainable Financial System, pages 151–171. Springer, 2018.

<a name="ft6">[6]</a>: Ariel Bergmann, Nick Hanley, and Robert Wright. Valuing the attributes of renewable energy investments. Energy policy, 34(9):1004–1014, 2006.