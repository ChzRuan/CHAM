cimport cython
from libc.math cimport sin, cos, log
import sympy



#Sine and Cosine integral functions used in Fourier transformation of NFW profile
# source: https://en.wikipedia.org/wiki/Trigonometric_integral#Auxiliary_functions

# if 0 < x < 4
def Si_lessThanFour_approxFunc(x):
    x2 = x**2
    x4 = x**4
    x6 = x**6
    x8 = x**8
    x10 = x**10
    x12 = x**12
    x14 = x**14
    
    akane = x * (1.0 - 4.54393409816329991*(1e-2)*(x2) + 1.15457225751016682*(1e-3)*x4 - 1.41018536821330254*(1e-5)*x6 + 9.43280809438713025*(1e-8)*x8 - 3.53201978997168357*(1e-10)*x10 + 7.08240282274875911*(1e-13)*x12 - 6.05338212010422477*(1e-16)*x14) / (1.0 + 1.01162145739225565*(1e-2)*x2 + 4.99175116169755106*(1e-5)*x4 + 1.55654986308745614*(1e-7)*x6 + 3.28067571055789734*(1e-10)*x8 + 4.5049097575386581*(1e-13)*x10 + 3.21107051193712168*(1e-16)*x12)
    return akane

def Ci_lessThanFour_approxFunc(x):
    x2 = x**2
    x4 = x**4
    x6 = x**6
    x8 = x**8
    x10 = x**10
    x12 = x**12
    x14 = x**14
    Euler_const = 0.577215664901532861
    
    
    kaki = Euler_const + log(x) + x2*(-0.25 + 7.51851524438898291*(1e-3)*x2 - 1.27528342240267686*(1e-4)*x4 + 1.05297363846239184*(1e-6)*x6 - 4.68889508144848019*(1e-9)*x8 + 1.06480802891189243*(1e-11)*x10 - 9.93728488857585407*(1e-15)*x12)/(1.0 + 1.1592605689110735*(1e-2)*x2 + 6.72126800814254432*(1e-5)*x4 + 2.55533277086129636*(1e-7)*x6 + 6.97071295760958946*(1e-10)*x8 + 1.38536352772778619*(1e-12)*x10 + 1.89106054713059759*(1e-15)*x12 + 1.39759616731376855*(1e-18)*x14)
    return kaki

# x > 4
# Si(x) = pi/2 - f(x)*cos(x) - g(x)*sin(x)
# Ci(x) = f(x)*sin(x) - g(x)*cos(x)
def f_func(x):
    xm2 = x**(-2)
    xm4 = x**(-4)
    xm6 = x**(-6)
    xm8 = x**(-8)
    xm10 = x**(-10)
    xm12 = x**(-12)
    xm14 = x**(-14)
    xm16 = x**(-16)
    xm18 = x**(-18)
    xm20 = x**(-20)
    
#    fenzi = 1.0 + 7.44437068161936700618*(1e2)*xm2 \
#                + 1.96396372895146869801*(1e5)*xm4 \
#                + 2.37750310125431834034*(1e7)*xm6 \
#                + 1.43073403821274636888*(1e9)*xm8 \
#                + 4.33736238870432522765*(1e10)*xm10 \
#                + 6.40533830574022022911*(1e11)*xm12 \
#                + 4.20968180571076940208*(1e12)*xm14 \
#                + 1.00795182980368574617*(1e13)*xm16 \
#                + 4.94816688199951963482*(1e12)*xm18 \
#                - 4.94701168645415959931*(1e11)*xm20
#    
#    fenmu = 1.0 + 7.46437068161927678031*(1e2)*xm2 \
#                + 1.97865247031583951450*(1e5)*xm4 \
#                + 2.41535670165126845144*(1e7)*xm6 \
#                + 1.47478952192985464958*(1e9)*xm8 \
#                + 4.58595115847765779830*(1e10)*xm10 \
#                + 7.08501308149515401563*(1e11)*xm12 \
#                + 5.06084464593475076774*(1e12)*xm14 \
#                + 1.43468549171581016479*(1e13)*xm16 \
#                + 1.11535493509914254097*(1e13)*xm18
    
    fff = (1.0  + 7.44437068161936700618*(1e2)*xm2     \
                + 1.96396372895146869801*(1e5)*xm4     \
                + 2.37750310125431834034*(1e7)*xm6     \
                + 1.43073403821274636888*(1e9)*xm8     \
                + 4.33736238870432522765*(1e10)*xm10   \
                + 6.40533830574022022911*(1e11)*xm12   \
                + 4.20968180571076940208*(1e12)*xm14   \
                + 1.00795182980368574617*(1e13)*xm16   \
                + 4.94816688199951963482*(1e12)*xm18   \
                - 4.94701168645415959931*(1e11)*xm20) /\
          (1.0  + 7.46437068161927678031*(1e2)*xm2     \
                + 1.97865247031583951450*(1e5)*xm4     \
                + 2.41535670165126845144*(1e7)*xm6     \
                + 1.47478952192985464958*(1e9)*xm8     \
                + 4.58595115847765779830*(1e10)*xm10   \
                + 7.08501308149515401563*(1e11)*xm12   \
                + 5.06084464593475076774*(1e12)*xm14   \
                + 1.43468549171581016479*(1e13)*xm16   \
                + 1.11535493509914254097*(1e13)*xm18) / x
    
    return fff


def g_func(x):
    xm2 = x**(-2)
    xm4 = x**(-4)
    xm6 = x**(-6)
    xm8 = x**(-8)
    xm10 = x**(-10)
    xm12 = x**(-12)
    xm14 = x**(-14)
    xm16 = x**(-16)
    xm18 = x**(-18)
    xm20 = x**(-20)
    
#    fenzi = 1.0 + 8.13595201151686150*(1e2)*xm2 \
#                + 2.35239181626478200*(1e5)*xm4 \
#                + 3.12557570795778731*(1e7)*xm6 \
#                + 2.06297595146763354*(1e9)*xm8 \
#                + 6.83052205423625007*(1e10)*xm10 \
#                + 1.09049528450362786*(1e12)*xm12 \
#                + 7.57664583257834349*(1e12)*xm14 \
#                + 1.81004487464664575*(1e13)*xm16 \
#                + 6.43291613143049485*(1e12)*xm18 \
#                - 1.36517137670871689*(1e12)*xm20
#
#    fenmu = 1.0 + 8.19595201151451564*(1e2)*xm2 \
#                + 2.40036752835578777*(1e5)*xm4 \
#                + 3.26026661647090822*(1e7)*xm6 \
#                + 2.23355543278099360*(1e9)*xm8 \
#                + 7.87465017341829930*(1e10)*xm10 \
#                + 1.39866710696414565*(1e12)*xm12 \
#                + 1.17164723371736605*(1e13)*xm14 \
#                + 4.01839087307656620*(1e13)*xm16 \
#                + 3.99653257887490811*(1e13)*xm18
    
    ggg =  (1.0 + 8.13595201151686150*(1e2)*xm2     \
                + 2.35239181626478200*(1e5)*xm4     \
                + 3.12557570795778731*(1e7)*xm6     \
                + 2.06297595146763354*(1e9)*xm8     \
                + 6.83052205423625007*(1e10)*xm10   \
                + 1.09049528450362786*(1e12)*xm12   \
                + 7.57664583257834349*(1e12)*xm14   \
                + 1.81004487464664575*(1e13)*xm16   \
                + 6.43291613143049485*(1e12)*xm18   \
                - 1.36517137670871689*(1e12)*xm20) /\
           (1.0 + 8.19595201151451564*(1e2)*xm2     \
                + 2.40036752835578777*(1e5)*xm4     \
                + 3.26026661647090822*(1e7)*xm6     \
                + 2.23355543278099360*(1e9)*xm8     \
                + 7.87465017341829930*(1e10)*xm10   \
                + 1.39866710696414565*(1e12)*xm12   \
                + 1.17164723371736605*(1e13)*xm14   \
                + 4.01839087307656620*(1e13)*xm16   \
                + 3.99653257887490811*(1e13)*xm18) / x**2
    
    return ggg


# Si(x) = pi/2 - f(x)*cos(x) - g(x)*sin(x)
def Si_largerThanFour_approxFunc(x):
    return 3.141592653589793238462643383279502884197169399375105820974944592307816406286/2 - f_func(x)*cos(x) - g_func(x)*sin(x)

    
# Ci(x) = f(x)*sin(x) - g(x)*cos(x)
def Ci_largerThanFour_approxFunc(x):
    return f_func(x)*sin(x) - g_func(x)*cos(x)

def NFWfunc_loop(double[:] rhoNFW, 
	int len_r,
	double[:] rhostmp_arr, 
	double[:] rstmp_arr, 
	double[:] mstmp_arr, 
	double[:] krs, 
	double kk_var, 
	double[:] cvtmp_arr, 
	double[:] rhotmp):
    cdef int j
    for j in range(len_r):
    # NFW density profile   
        rhoNFW[j] = 4.0*3.141592653589793238462643383279502884197169399375105820974944592307816406286*rhostmp_arr[j]*rstmp_arr[j]**3.0/mstmp_arr[j]
        krs[j] = kk_var*rstmp_arr[j]

        if (1.0+cvtmp_arr[j])*krs[j] < 4:
            si_apple = Si_lessThanFour_approxFunc((1.0+cvtmp_arr[j])*krs[j])
            ci_apple = Ci_lessThanFour_approxFunc((1.0+cvtmp_arr[j])*krs[j])
        else:
            si_apple = Si_largerThanFour_approxFunc((1.0+cvtmp_arr[j])*krs[j])
            ci_apple = Ci_largerThanFour_approxFunc((1.0+cvtmp_arr[j])*krs[j])
        
        if krs[j] < 4:
            si_banana = Si_lessThanFour_approxFunc(krs[j])
            ci_banana = Ci_lessThanFour_approxFunc(krs[j])

        else:
            si_banana = Si_largerThanFour_approxFunc(krs[j])
            ci_banana = Ci_largerThanFour_approxFunc(krs[j])

        rhotmp[j] = sin(krs[j]) * (si_apple - si_banana)
        rhotmp[j] = rhotmp[j] - sin(cvtmp_arr[j]*krs[j])/krs[j]/(1.0 + cvtmp_arr[j])
        rhotmp[j] = rhotmp[j] + cos(krs[j])*(ci_apple - ci_banana)

        rhoNFW[j] = rhoNFW[j] * rhotmp[j]
    return rhoNFW