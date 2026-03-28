public class RequestWrapper {
    public data data{get;set;}
    public String name{get;set;}
	
    public class data{
		public String CPUmodel{get;set;}
		public Decimal price{get;set;}
		public String HardDiskSize{get;set;}
		public Integer year{get;set;}
	}

}