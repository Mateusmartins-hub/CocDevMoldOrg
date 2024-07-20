import { LightningElement, wire } from 'lwc';
//import getConsultorias from '@salesforce/apex/GEN_ChartController.getCOs';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/Chatjs43';
//import plugin from '@salesforce/resourceUrl/PluginCharjs';
import getConsultorias2 from '@salesforce/apex/GEN_ChartController.getCOsData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Gen_opportunitychart extends LightningElement {

    mychart1 = '';
    mychart2 ='';

    scrollBoxBody = '';

    noData = '';
   
    initialRender = false;
    
    data1 ="";
    data2= "";


    firstLoad(dStartIn, dEndIn) {
        getConsultorias2({dStartIn: dStartIn, dEndIn: dEndIn})
        .then(data => {
            let chartPresData = [];
            let chartNPresData = [];
            let escolaLabel = [];
            let chartLiderData = [];
            let chartConsultoData = [];
            let datalabels=[];
            //var i = 0;
            var Consultor = '';
            var Lider = '';
            var Escola= '';
            //var cos = data;
            data.forEach((co, i, cos)=> {
    
                if(i == 0){
                    Lider = cos[i].Lider; 
                    Consultor = cos[i].Consultor;
                    Escola = cos[i].Escola;
                    

                    if(Lider === undefined) Lider = '';
                    if(Consultor === undefined) Consultor = '';
                    if(Escola === undefined) Escola = '';

                    //datalabels.push('    ' + Lider + '    '+ Consultor + '    ' + cos[i].Escola);
                    datalabels.push(Lider + Consultor.padStart(20, ' ') + Escola.padStart(30, ' '));          
                    chartPresData.push(co.Presenciais);
                    chartNPresData.push(co.Online);
                    escolaLabel.push(co.Escola);
                    chartLiderData.push(co.Lider);
                    chartConsultoData.push(co.Consultor);
    
                    return;
                }
    
                if( cos[i].Lider != cos[i-1].Lider && i!=0){
                    Lider = cos[i].Lider;
                }else{
                    Lider = '';
                }
    
                if((cos[i].Consultor != cos[i-1].Consultor || cos[i].Lider != data[i-1].Lider) && i!=0){
                    Consultor = cos[i].Consultor;
                }else{
                    Consultor = '';
                }


                Escola = cos[i].Escola;
                    

                if(Lider === undefined) Lider = '';
                if(Consultor === undefined) Consultor = '';
                if(Escola === undefined) Escola = '';
    
                //datalabels.push(Lider + '    '+ Consultor + '    ' + cos[i].Escola)
                datalabels.push(Lider + Consultor.padStart(20, ' ') + Escola.padStart(30, ' ')); 
                chartPresData.push(co.Presenciais);
                chartNPresData.push(co.Online);
                escolaLabel.push(co.escola);
                chartLiderData.push(co.Lider);
                chartConsultoData.push(co.Consultor);   
            });
    
            if (data.length === 0) {
                const evt = new ShowToastEvent({
                    title: 'Por favor verifique as datas',
                    message: 'Não existem dados para esse período de tempo, por favor insira novos valores',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }

            var charData =  {
                labels: datalabels,
                datasets: [
                    {
                        yAxisID: 'yAxis1',
                        label: 'Visitas Presenciais',
                        backgroundColor: 'Blue',
                        data: chartPresData
    
                    },
                    {
                        yAxisID: 'yAxis1',
                        label: 'Visitas Não Presenciais',
                        backgroundColor: 'orange',
                        data: chartNPresData,
                    },
                ],
            };
    
    
    
            const ctx = this.template.querySelector("[data-id='myChart']").getContext('2d');
    
            //Chart.register(ChartDataLabels);
    
            this.mychart1  = new window.Chart(ctx, {
                type: 'bar',
                data: charData,
                options: {
                    maintainAspectRatio: false,
                    layout:{
                        padding: {
                            right: 20
                        }
                    },
                    indexAxis: 'y',
                    plugins :{
                        legend:{
                            position: 'top',
                            display: true
                        },
                        datalabels: {
                            anchor: 'end',
                            align: 'end',
                            offset: 6,
                            formatter: Math.round,
                            font: {
                              weight: 'bold'
                            }
                          }
                    },
                    scales: {
                        yAxes: [
                            {
                                id: 'yAxis1',
                                type: 'category',
                                offset: true,
                                tickLength:20,
                                tickColor: "DarkSlateBlue" ,
                                tickThickness: 5,
                                gridLines: {
                                    drawOnChartArea: false
                                },  
                            },
                        ], 
                        x: {
    
                                beginAtZero: true,
                                grid: {
                                    drawTicks: false,
                                    drawBorder: false
                                },
                                ticks: {
                                    display: false
                                }
                            }   
                    },
                    responsive: false,    
                    },
                });
    
                const ctx2 = this.template.querySelector("[data-id='myChart2']");
    
                this.scrollBoxBody = this.template.querySelector('.scrollBoxBody');
    
                
                
                
                var charData2 =  {
                    labels: [],
                    datasets: [
                        {
                            label: 'Visitas Presenciais',
                            backgroundColor: 'Blue',
                            data: chartPresData
        
                        },
                        {
                            label: 'Visitas Não Presenciais',
                            backgroundColor: 'orange',
                            data: chartNPresData,
                        },
                    ],
                };
    
                this.mychart2  = new window.Chart(ctx2, {
                    type: 'bar',
                    data: charData2,
                    options: {
                        maintainAspectRatio: false,
                        layout:{
                            padding: {
                                right: 36
                            }
                        },
                        indexAxis: 'y',
                        plugins :{
                            legend:{
                                display: false
                            },
                        },
                        scales: {
                            x: {
                                afterFit:((context) => {
                                    context.height  += 30
                                }),
                                beginAtZero: true,
                            },
                            y : { 
                                afterFit:((context) => {
                                    context.width += this.mychart1.chartArea.left -1
                                }),
                                grid: {
                                    drawTicks: false
                                }
                            }
                        },
                        responsive: false
                    }
                });
               
    
                //this.mychart2.resize();
    
    
                if(this.mychart1.data.labels.length > 2){
    
                    const newHeigth = 300 + (this.mychart1.data.labels.length - 2) *20
                    this.scrollBoxBody.style.height = `${newHeigth}px`
                }
                this.mychart1.resize();
                this.mychart2.resize();
    
            });
    
    }


    handleStartData(event) {
        this.data1 = event.target.value;
    };

    handleFinalData(event) {
        this.data2 = event.target.value;
    };

    handleNext() {
        

        if( (this.data1 == '' || this.data1 === null ) && (this.data2 == '' || this.data2 ===  null) ){            

            this.mychart1.destroy();
            this.mychart2.destroy();
           

            this.firstLoad(null, null);
            

        }else{
            this.mychart1.destroy();
            this.mychart2.destroy();
            this.scrollBoxBody = this.template.querySelector('.scrollBoxBody');
            this.scrollBoxBody.style.height = '300px';

            this.firstLoad(this.data1, this.data2);
            /*
            var consultorias = getConsultorias2({dStartIn:this.data1 , dEndIn:this.data2}).then(consultorias => {


                let chartPresData = [];
                let chartNPresData = [];
                let escolaLabel = [];
                let chartLiderData = [];
                let chartConsultoData = [];
                let datalabels=[];
                //var i = 0;
                var Consultor = '';
                var Lider = '';
                var Escola = '';
                //var cos = data;
                consultorias.forEach((co, i, cos)=> {
    
                    if(i == 0){
                        Lider = cos[i].Lider; 
                        Consultor = cos[i].Consultor;
                        Escola = cos[i].Escola;

                        if(Lider === undefined) Lider = '';
                        if(Consultor === undefined) Consultor = '';
                        if(Escola === undefined) Escola = '';
    
                        //datalabels.push('    ' + Lider + '    '+ Consultor + '    ' + cos[i].Escola);
                        datalabels.push(Lider + Consultor.padStart(20, ' ') + Escola.padStart(30, ' '));          
                        chartPresData.push(co.Presenciais);
                        chartNPresData.push(co.Online);
                        escolaLabel.push(co.Escola);
                        chartLiderData.push(co.Lider);
                        chartConsultoData.push(co.Consultor);
    
                        return;
                    }
    
                    if( cos[i].Lider != cos[i-1].Lider && i!=0){
                        Lider = cos[i].Lider;
                    }else{
                        Lider = '';
                    }
    
                    if((cos[i].Consultor != cos[i-1].Consultor || cos[i].Lider != consultorias[i-1].Lider) && i!=0){
                        Consultor = cos[i].Consultor;
                    }else{
                        Consultor = '';
                    }

                        
                    Escola = cos[i].Escola;
                        

                    if(Lider === undefined) Lider = '';
                    if(Consultor === undefined) Consultor = '';
                    if(Escola === undefined) Escola = '';
    
                    //datalabels.push(Lider + '    '+ Consultor + '    ' + cos[i].Escola)
                    datalabels.push(Lider + Consultor.padStart(20, ' ') + Escola.padStart(30, ' ')); 
                    chartPresData.push(co.Presenciais);
                    chartNPresData.push(co.Online);
                    escolaLabel.push(co.escola);
                    chartLiderData.push(co.Lider);
                    chartConsultoData.push(co.Consultor);   
                });
                
    
                var charData3 =  {
                    labels: datalabels,
                    options:{
                        display: false
                    },
                    datasets: [
                        {
                            yAxisID: 'yAxis1',
                            label: 'Visitas Presenciais',
                            backgroundColor: 'Blue',
                            data: chartPresData
    
                        },
                        {
                            yAxisID: 'yAxis1',
                            label: 'Visitas Não Presenciais',
                            backgroundColor: 'orange',
                            data: chartNPresData
                        },
                    ],
                };
                
                
                if (consultorias.length === 0) {
                        const evt = new ShowToastEvent({
                            title: 'Por favor verifique as datas',
                            message: 'Não existem dados para esse período de tempo, por favor insira novos valores',
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    
                }

                this.mychart1.data = charData3;
                this.mychart1.update();

                charData3.labels = [];
                this.mychart2.data = charData3;

                this.mychart2.update();
                //alert(consultorias.length )


                this.mychart1.resize();
                this.mychart2.resize();

            });*/
   
        }
    }

    
   
    //chartConfiguration;
    



    renderedCallback() {
        if(this.initialRender) {
            return;
        } 
        this.initialRender = true;   
            Promise.all([loadScript(this, chartjs)/*, loadScript(this, plugin)*/])
            .then(() => {
            const htmlLegendPlugin = {
                id: 'htmlLegend',
                afterUpdate(chart, args, options) {
                    chart.afterUpdate(chart, args, options)
                }
            };
            this.firstLoad(null, null);
            
            })
            .catch(error => {
            });
    }
    

     
}