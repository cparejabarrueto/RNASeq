

##<center>Tutorial: RNA-Seq para identificación de sRNAs bacterianos</center>

<center> Autor: Dra. Claudia Pareja </center>
<center> e-mail: cparejabarrueto@gmail.com </center> 


####El objetivo es hacer la anotación, cuantificación de transcritos y enriquecimiento funcional de RNAs pequeños provenientes de la bacteria *E. Coli* comensal.

Durante este tutorial se trabajará con siguientes archivos fastq como resultado de secuenciación en la plataforma Illumina MiSeq: 

<code>A-RNA-HS-LB-S1-L001-R1-001.fastq </code>
<code>B-RNA-HS-SALES-S2-L001-R1-001.fastq</code>

El primer archivo corresponde a una muestra en medio LB y el segundo a una muestra expuesta a SALES.


###Parte 1: Preparación de programas y archivos


**1.1** Primero, vamos a descargar el programa de Zytnicki, et al. 2020 (<a href="https://github.com/mzytnicki/mmannot">mmannot</a>). Podemos descargar el archivo .ZIP o instalar **mmannot** desde la terminal con el siguiente comando: <code>git clone https://github.com/mzytnicki/mmannot.git</code>

Este comando creará una carpeta llamada **mmannot**, acá copiaremos los dos archivos fastq.

**1.2** Ahora, instalaremos **bowtie**, para esto vamos al link <a href="https://github.com/BenLangmead/bowtie/releases">https://github.com/BenLangmead/bowtie/releases</a>, y descargamos el archivo comprimido correspondiente a su sistema operativo. Por ejemplo: *bowtie-1.3.1-macos-x86_64.zip*

Descomprimimos este archivo y se creará la carpeta **bowtie-1.3.1-macos-x86_64**

**1.3** Ahora, instalaremos **samtools**. Para esto desde la terminal hacemos:

<code>brew install samtools</code>

Revisamos que se haya instalado correctamente si podemos ejecutar el comando samtools en la terminal:

<code>samtools </code>

Se debería despleagr el modo de uso del programa samtools.

<img src="https://github.com/cparejabarrueto/talleres_bioinf/blob/main/samtools.png?raw=true" alt="samtools">

**1.5** Ahora instalamos zlib para poder correr ./mmannot 

<code>brew install zlib</code>

**1.4** Finalmente, descargamos el genoma de referencia de *Escherichia coli HS*. 

Vamos a <a href="https://www.ncbi.nlm.nih.gov/assembly/GCF_000017765.1">https://www.ncbi.nlm.nih.gov/assembly/GCF_000017765.1</a> 

<img src="https://github.com/cparejabarrueto/talleres_bioinf/blob/main/ref_genome.png?raw=true" alt="ref_genome">

Hacemos click en Download Assembly, seleccionamos RefSeq y hacemos la descarga de los archivos Source database -> RefSeq y File type Genomic FASTA, Genomic GTF y Genomic GFF. Localizamos ambos archivos en la carpeta mmannot/ y descomprimimos cada archivo .tar con un doble click y se crea la carpeta **genome\_assemblies\_genome_fasta** , **genome\_assemblies\_genome_gtf** y **genome\_assemblies\_genome_gff**

Ahora ya tenemos todos los programas y archivos que utilizaremos para hacer la anotación de transcritos.



###Parte 2: Anotación y cuantificación de transcritos

**2.1** Comenzamos abriendo la terminal, y desde la carpeta home, entramos a la carpeta del programa mmannot:

<code>cd mmannot</code>

**2.2** Desde acá, vamos a contruir todos los indices que existen del genoma de referencia con bowtie:

<code>./../bowtie-1.3.1-macos-x86\_64/bowtie-build ../genome\_assemblies\_genome\_fasta/ncbi-genomes-2022-10-25/GCF\_000017765.1\_ASM1776v1_genomic.fna ecoli</code>

Este comando creará un archivo llamados ecoli y con extención .ebwt

**2.3** Ahora, creamos un archivo .bam, que almacena todos los alineamientos de reads en el genoma de referencia.

<code>./../bowtie-1.3.1-macos-x86\_64/bowtie -a -v 3 -p 4 -m 1 -S ecoli --strata --best -l 14 A-RNA-HS-LB\_S1\_L001\_R1_001.fastq | samtools view -b -S  | samtools sort -o  A-sorted.bam </code>

<code>./../bowtie-1.3.1-macos-x86\_64/bowtie -a -v 3 -p 4 -m 1 -S ecoli --strata --best -l 14 B-RNA-HS-SALES\_S2\_L001\_R1_001.fastq | samtools view -b -S  | samtools sort -o  B-sorted.bam </code>

**2.4** Ahora hacemos el archivo de configuración donde se indican los parámetros de interés para hacer la anotación.

Un ejemplo de contenido es este <a href="https://raw.githubusercontent.com/cparejabarrueto/talleres_bioinf/main/configA.txt"> archivo </a>

Descarguemos el archivo de ejemplo adentro de la carpeta **mmannot**. 

**2.5** Ahora ejecutamos el siguiente comando para hacer la anotación:

<code> ./mmannot -a GCF\_000017765.1\_ASM1776v1_genomic.gtf -r A-sorted.bam -c configA.txt -M output-A.txt </code>

<code> ./mmannot -a GCF\_000017765.1\_ASM1776v1_genomic.gtf -r B-sorted.bam -c configA.txt -M output-B.txt </code>

Se crearán los archivos output-A.txt y output-B.txt que contiene los elementos funcionales, transcritos, y sus cuantificaciones.

**2.6** En este punto, es posible buscar manualmente cada uno de los identificadores de los transcritos en <a href="https://biocyc.org/organism-summary?object=GCF_000017765">Biocyc</a>. 

**2.7** También, podemos filtrar los archivos para encontrar específicamente los productos de RNA utilizando el siguiente archivo <a href="https://raw.githubusercontent.com/cparejabarrueto/talleres_bioinf/main/script.R"> script.R </a>

**2.8** Instalación de RStudio. Primero descargamos Rstudio para Mac. Vamos, a seguir las siguientes <a href="https://posit.co/download/rstudio-desktop/">Indicaciones para RStudio</a>

**2.9** Para trabajar desde Rstudio vamos a localizar la carpeta de trabajo, **Session -> Set Working Directory -> Choose Directory** , y seleccionamos la carpeta **mmannot**.

Ahora cargamos el pequeño script **File -> Open File -> script.R** y hacemos click en **Run**