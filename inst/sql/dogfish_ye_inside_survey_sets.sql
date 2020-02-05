SELECT 
  S.SURVEY_SERIES_ID,
  SURVEY_SERIES_DESC,
  S.SURVEY_ID,
  SURVEY_DESC,
  YEAR(FE_BEGIN_RETRIEVAL_TIME) YEAR,
  FE.FISHING_EVENT_ID,
  FE_START_LATTITUDE_DEGREE + FE_START_LATTITUDE_MINUTE / 60 AS LATITUDE,
  -(FE_START_LONGITUDE_DEGREE + FE_START_LONGITUDE_MINUTE / 60) AS LONGITUDE,
  FE_END_DEPLOYMENT_TIME,
  FE_BEGIN_RETRIEVAL_TIME,
  FE.GROUPING_CODE,
  GROUPING_DESC,
  GROUPING_DEPTH_ID,
  FE_BEGINNING_BOTTOM_DEPTH AS DEPTH_M,
  FE_BOTTOM_WATER_TEMPERATURE,
  HOOK_CODE,
  SKATE_COUNT,
  LGLSP_HOOK_COUNT,
  LGLSP_HOOK_SPACING,
  0.0024384 * 0.009144 * LGLSP_HOOK_COUNT AS AREA_SWEPT_KM2, --0.024384 = 8 ft hook spacing (to calculate line length with hook count); 0.009144 = 2*gangion length (= area width)
  C.SPECIES_CODE,
  CATCH_COUNT,
  CATCH_WEIGHT
  FROM FISHING_EVENT FE
  INNER JOIN TRIP_SURVEY TS ON FE.TRIP_ID = TS.TRIP_ID
  INNER JOIN FISHING_EVENT_CATCH FEC ON FEC.TRIP_ID = FE.TRIP_ID AND FEC.FISHING_EVENT_ID = FE.FISHING_EVENT_ID
  INNER JOIN CATCH C ON C.CATCH_ID = FEC.CATCH_ID
  INNER JOIN SURVEY S ON S.SURVEY_ID = TS.SURVEY_ID
  INNER JOIN SURVEY_SERIES SS ON SS.SURVEY_SERIES_ID = S.SURVEY_SERIES_ID
  INNER JOIN SPECIES SP ON SP.SPECIES_CODE = C.SPECIES_CODE
  INNER JOIN LONGLINE_SPECS LLSP ON LLSP.FISHING_EVENT_ID = FE.FISHING_EVENT_ID
  INNER JOIN GROUPING G ON G.GROUPING_CODE = FE.GROUPING_CODE
  WHERE S.SURVEY_SERIES_ID IN (76) AND
	C.SPECIES_CODE IN ('442', '044')
	ORDER BY C.SPECIES_CODE

-- or get df for all fe's and separate df for catch of each spp and join in R

SELECT
  S.SURVEY_SERIES_ID,
  SURVEY_SERIES_DESC,
  S.SURVEY_ID,
  SURVEY_DESC,
  YEAR(FE_BEGIN_RETRIEVAL_TIME) YEAR,
  FE.FISHING_EVENT_ID,
  FE_START_LATTITUDE_DEGREE + FE_START_LATTITUDE_MINUTE / 60 AS LATITUDE,
  -(FE_START_LONGITUDE_DEGREE + FE_START_LONGITUDE_MINUTE / 60) AS LONGITUDE,
  FE_END_DEPLOYMENT_TIME,
  FE_BEGIN_RETRIEVAL_TIME,
  FE.GROUPING_CODE,
  GROUPING_DESC,
  GROUPING_DEPTH_ID,
  FE_BEGINNING_BOTTOM_DEPTH AS DEPTH_M,
  FE_BOTTOM_WATER_TEMPERATURE,
  HOOK_CODE,
  SKATE_COUNT,
  LGLSP_HOOK_COUNT,
  LGLSP_HOOK_SPACING,
  0.0024384 * 0.009144 * LGLSP_HOOK_COUNT AS AREA_SWEPT_KM2 --0.024384 = 8 ft hook spacing (to calculate line length with hook count); 0.009144 = 2*gangion length (= area width)
  FROM FISHING_EVENT FE
  INNER JOIN TRIP_SURVEY TS ON FE.TRIP_ID = TS.TRIP_ID
  INNER JOIN SURVEY S ON S.SURVEY_ID = TS.SURVEY_ID
  INNER JOIN SURVEY_SERIES SS ON SS.SURVEY_SERIES_ID = S.SURVEY_SERIES_ID
  INNER JOIN LONGLINE_SPECS LLSP ON LLSP.FISHING_EVENT_ID = FE.FISHING_EVENT_ID
  INNER JOIN GROUPING G ON G.GROUPING_CODE = FE.GROUPING_CODE
  WHERE S.SURVEY_SERIES_ID IN (76) 


  SELECT FEC.TRIP_ID,
  FEC.FISHING_EVENT_ID,
  C.SPECIES_CODE,
  SUM(CATCH_COUNT) CATCH_COUNT,
  SUM(CATCH_WEIGHT) CATCH_WEIGHT
  FROM FISHING_EVENT_CATCH FEC 
	INNER JOIN CATCH C ON C.CATCH_ID = FEC.CATCH_ID
	INNER JOIN TRIP_SURVEY TS ON TS.TRIP_ID = FEC.TRIP_ID
	INNER JOIN SURVEY S ON S.SURVEY_ID = TS.SURVEY_ID
  WHERE C.SPECIES_CODE IN ('044', '442') AND SURVEY_SERIES_ID = 76
  GROUP BY FEC.TRIP_ID,
  FEC.FISHING_EVENT_ID,
  C.SPECIES_CODE
  ORDER BY FEC.FISHING_EVENT_ID