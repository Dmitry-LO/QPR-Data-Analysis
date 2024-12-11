class FieldNames:
    """
    Column names in the data file. Edit if something changes!

    Key Fields:
        PEAK_FIELD: "Peak Field on Sample [mT]".
        SENS_A: "LS336 A [K]" (similarly for B, C, D).
        SET_TEMP: Set Temp [K].
        RS: Surface Resistance [nOhm].
    """
    
    SET_TEMP = "Set Temp [K]"
    SET_FREQ = "Set Freq [Hz]"
    DUTY_CYCLE = "Duty Cycle [%]"
    PULSE_PERIOD = "Pulse Period [ms]"
    P_FORW = "P_forw (giga)"
    P_REFL = "P_refl (giga)"
    P_TRANS = "P_trans (giga)"
    CW_POWER = "CW Power (Tek)"
    PULSE_POWER = "Pulse Power (Tek)"
    PEAK_POWER = "Peak Power (Tek)"
    DC_MEAS = "DC meas [%] (Tek)"
    P_TRANS_CALC = "P_trans for calc"
    FREQ_MEAS = "Freq. (meas.) [Hz]"
    Q_FPC = "Q_FPC"
    Q_PROBE = "Q_Probe"
    C1 = "c1"
    C2 = "c2"
    HEATER_RESISTANCE = "Heater Resistance [Ohm]"
    REF_V = "Ref. Voltage"
    HEATER_V = "Heater Voltage"
    HEATER_P = "Heater Power [mW]"
    P_DISS = "P_diss [mW]"
    PEAK_FIELD = "Peak Field on Sample [mT]"
    RS = "Surface Resistance [nOhm]"
    SENS_A = "LS336 A [K]"
    SENS_B = "LS336 B [K]"
    SENS_C = "LS336 C [K]"
    SENS_D = "LS336 D [K]"
    MAGNETIC_FIELD = "Magnetic Field [uT]"
    PLL_ATTENUATOR = "PLL Attenuator [dB]"
    PLL_PHASE = "PLL Phase [deg]"
    KEYSIGHT_FORW = "Keysight forw [dBm]"
    KEYSIGHT_REFL = "Keysight refl [dBm]"
    KEYSIGHT_TRANS = "Keysight trans [dBm]"
    DC_CURRENT = "DC current [mA]"
    DC_REF_CURRENT = "DC Ref current [mA]"
    FREQ_HAMEG = "Freq Hameg [Hz]"
    DATE = "Date"
    TIME = "Time"
    # Those columns will be added:
    RUN = "Run"
    FNAME = "File Name"
    DATETIME = "Date_Time"
    # Auxillary
    RUNMARK = "Run" #Pattern which will be looked to determain the run numner in the filename