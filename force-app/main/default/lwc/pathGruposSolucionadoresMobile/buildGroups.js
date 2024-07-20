const activeGroup = ({
    currentItemGroup,
    currentItemIndex,
    caseGroup,
    caseGroupIndex,
    caseStatus,
    caseMilestoneStatus,
}) => {
    return (
        currentItemGroup === caseGroup &&
        currentItemIndex === caseGroupIndex &&
        caseStatus !== "Aguardando Cliente" /* &&
        (caseMilestoneStatus === "Conforme" || caseMilestoneStatus === "Compliant") */
    );
};

const brokenSLA = ({
    currentItemGroup,
    currentItemIndex,
    caseGroup,
    caseGroupIndex,
    caseStatus,
    caseMilestoneStatus,
}) => {
    return (
        currentItemGroup === caseGroup &&
        currentItemIndex === caseGroupIndex &&
        caseStatus !== "Aguardando Cliente" &&
        caseMilestoneStatus !== "Conforme" &&
        caseMilestoneStatus !== "Compliant" &&
        caseMilestoneStatus !== ""
    );
};

const waitingCustomer = ({
    currentItemGroup,
    currentItemIndex,
    caseGroup,
    caseGroupIndex,
    caseStatus,
}) => {
    return (
        currentItemGroup === caseGroup &&
        currentItemIndex === caseGroupIndex &&
        caseStatus === "Aguardando Cliente"
    );
};

const checkedGroup = ({
    currentItemGroup,
    currentItemIndex,
    caseGroup,
    caseGroupIndex,
    groupsHistory,
}) => {
    return (
        currentItemIndex !== caseGroupIndex && 
        groupsHistory.filter((item) => item.nome == currentItemGroup && item.index == currentItemIndex).length > 0
    );
};

const disabledGroup = ({
    currentItemGroup,
    currentItemIndex,
    caseGroup,
    caseGroupIndex,
}) => {
    return currentItemGroup !== caseGroup || currentItemIndex !== caseGroupIndex;
};

export default function buildGroup(data) {
    const conditions = {
        checkedGroup,
        disabledGroup,
        brokenSLA,
        waitingCustomer,
        activeGroup,
    };

    return Object.keys(conditions)[
        Object.keys(conditions).indexOf(
            Object.keys(conditions).find((condition) => conditions[condition](data))
        )
    ];
}