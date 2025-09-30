--Divine Serpent
function c700000119.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --cannot be target / immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    local e3=e2:Clone()
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    c:RegisterEffect(e3)

    --on special summon success
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c700000119.sucop)
    c:RegisterEffect(e4)

    --attack cost
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_ATTACK_COST)
    e5:SetCost(c700000119.atcost)
    e5:SetOperation(c700000119.atop)
    c:RegisterEffect(e5)
end

--Special Summon success: make player unable to lose, then set LP to 0
function c700000119.sucop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    -- Apply cannot lose effects BEFORE LP becomes 0
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_LOSE_LP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,0)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_LOSE_DECK)
    c:RegisterEffect(e2)

    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
    c:RegisterEffect(e3)

    -- Now discard hand and set LP to 0
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
    Duel.SetLP(tp,0)
end

--Attack cost: must be able to discard 10 cards from Deck
function c700000119.atcost(e,c,tp)
    return Duel.IsPlayerCanDiscardDeckAsCost(tp,10)
end

--Attack cost operation: discard 10 cards from Deck
function c700000119.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,10,REASON_COST)
end
