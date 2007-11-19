#
# $Id: der.py,v 1.1 2007-11-19 14:29:08 joishi Exp $
#
"""
this is a wrapper for the actual derivatives, currently 6th order with
ghost zones included (pencil-code style).
"""
import der_6th_order_w_ghosts as der
xder = der.xder_6th
yder = der.yder_6th
zder = der.zder_6th

xder2 = der.xder2_6th
yder2 = der.yder2_6th
zder2 = der.zder2_6th
