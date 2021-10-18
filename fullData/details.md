Dataset combining company cfp ratios, temperature data, and bushfire data by company reporting period for years 2002 - 2020.

Temperature data is in form raw (direct temperatures for month within report peiod where X1 = January, X12 = December etc), 
basis expansion coefficients (cos1, cos2 correspond to cos(1*2pi/12) and cos(2*2pi/12) etc as determined by 12 month periodicity),
functional principle component coefficients (dimension reduction).
Note that basis expansions used Jan data at time t = 0.5, up to Dec data being at time t = 11.5.

Bushfire data is recorded for Jan-Dec for each corresponding year. To account for companies with mismatched reporting periods the following breakdown was used:
- if start month is Jan-Oct, then that year's bushfire data is used (justified via assumption of delayed impacts)
- if start month is Nov or Dec, then linear interpolation is used (i.e. Nov = 2/3*same year + 1/3*next year; and Dec = 1/3*same year + 2/3* next year)
