package make_odf;

public interface IPipeSet {

	public void addPipe(Pipe p);

	public String getKindName();

	public String getName();

	public Pipe getPipe(int index);

	public boolean isPercussive();

	public void setBasicAttributes(Pipe p);
}