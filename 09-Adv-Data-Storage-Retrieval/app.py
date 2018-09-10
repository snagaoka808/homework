# Dependencies
import datetime as dt
import numpy as np
import pandas as pd

# SQLAlchemy
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, inspect, func, desc, extrac

# Flask
from flask import Flask, jsonify

# Relative Date
from dateutil.relativedelta import relativedelta


# Database Setup 

engine = create_engine("sqlite:///hawaii.sqlite")
Base = automap_base()
Base.prepare(engine, reflect=True)
Measurement = Base.classes.measurement
Station = Base.classes.station
session = Session(bind=engine)


# Flask Setup 
app = Flask(__name__)

@app.route("/")
def welcome():
	return(
		f"Climate Analysis API<br/>"
		f"Available Routes:<br/>"
		F"/api/v1.0/precipitation\n"
		F"/api/v1.0/stations\n"
		F"/api/v1.0/tobs\n"
		F"/api/v1.0/temp/<start>\n"
		F"/api/v1.0/temp/<start>/<end>\n"
	)

@app.route("/api/v1.0/precipitation")
def precipitation():
	"""Return the precipitation data for the last year"""
	# Calculate the date 1 year ago from today
	prev_year = dt.date.today() - dt.timedelta(days=365)

	# Query for the date and precipitation for the last year
	precipitation = session.query(Measurement.date, Measurement.prcp).\
		filter(Measurement.date >= prev_year).all()

	# Dictionary with date and precipitation
	precip = {date: prcp for date, prcp in precipitation}
	return jsonify(precip)

@app.route("/api/v1.0/stations")
def stations():
	"""Return a json list of stations from the dataset"""
	results = session.query(Station.station).all()

	# Unravel results into a 1D array and convert to a list
	stations = list(np.ravel(results))
	return jsonify(stations)

@app.route("/api/v1.0/tobs")
def temp_monthly():
	"""Return the temperature  observations (tobs) for previous year."""
	# Calulate the date 1 year ago from today
	prev_year = dt.date.today() - dt.timedelta(days=365)

	# Query the primary station for all tobs from the last year
	results = session.query(Measurement.tobs).\
		filter(Measurement.station == '').\
		filter(Measurement.date >= prev_year).all()

	# Unravel results into a 1D array and convert to a list
	temps = list(np.ravel(results))

	# Return the results
	return jsonify(temps)

@app.route("/api/v1.0/temp/<start>")
@app.route("/api/v1.0/temp/<start>/<end>")
def stats(start=None, end=None):
	"""Return TMIN, TAVG, TMAX"""

	# Select statement
	sel = [func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)]

	if not end:
		# calculate TMIN, TAVG, TMAX for dates greater than start
		results = session.query(*sel).\
			filter(Measurement.date >= start).all()
		# Unravel results into a 1D array and convert to a list
		temps = list(np.ravel(results))
		return jsonify(temps)

	#calculate TMIN, TAVG, TMAX with start and stop
	results = session.query(*sel).\
		filter(Measurement.date >= start).\
		filter(Measurement.date <= end).all()
	# Unravel results into a 1D array and convert to a list
	temps = list(np.ravel(results))
	return jsonify(temps)

if __name__ == '__main__':
	app.run()