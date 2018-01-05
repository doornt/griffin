export declare class BaseComponent {
    private $ast;
    private $view;
    constructor(pugJson: any);
    $rebuildAst(): void;
    readonly id: string;
    init(): void;
    viewDidLoad(): void;
}
