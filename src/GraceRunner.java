import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

public class GraceRunner {
	public static void main(String[] args) throws Exception {

		StringBuilder input = new StringBuilder();
		input.append("var a: string;");
		input.append("var b, c = b  + a: int; ");

		GraceLexer lexer = new GraceLexer(CharStreams.fromString(input.toString()));
		CommonTokenStream tokens = new CommonTokenStream(lexer);

		GraceParser parser = new GraceParser(tokens);

		ParseTree tree = parser.grace();

		Listener listener = new Listener();

		ParseTreeWalker walker = new ParseTreeWalker();

		walker.walk(listener, tree);

		// System.out.println("Arvore: "+ tree.toStringTree(parser));

	}

	public String compilar(String codigo) {
		
		HanglingErrors.resetListErros();
		
		GraceLexer lexer = new GraceLexer(CharStreams.fromString(codigo));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		lexer.removeErrorListeners();
		lexer.addErrorListener(ErrorListener.INSTANCE);

		GraceParser parser = new GraceParser(tokens);
		parser.removeErrorListeners();
		parser.addErrorListener(ErrorListener.INSTANCE);
		
		ParseTree tree = parser.programa();

		Listener listener = new Listener();


		ParseTreeWalker walker = new ParseTreeWalker();

		walker.walk(listener, tree);

		if(HanglingErrors.mostrarErro().length() == 0) 
			return "Compilado com sucesso !!!";

		return HanglingErrors.mostrarErro();
	}
}